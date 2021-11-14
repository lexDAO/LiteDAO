// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.0;

import './LiteDAOtoken.sol';
import './LiteDAOnftHelper.sol';

/// @notice Simple gas-optimized DAO core module.
contract LiteDAO is LiteDAOtoken, LiteDAOnftHelper {
    /*///////////////////////////////////////////////////////////////
                                  EVENTS
    //////////////////////////////////////////////////////////////*/

    event NewProposal(uint256 indexed proposal);

    event VoteCast(address indexed voter, uint256 indexed proposal, bool indexed approve);

    event ProposalProcessed(uint256 indexed proposal);

    /*///////////////////////////////////////////////////////////////
                              DAO STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public proposalCount;

    uint256 public votingPeriod;

    uint256 public quorum; // 1-100

    uint256 public supermajority; // 1-100

    bool private initialized;

    mapping(uint256 => Proposal) public proposals;

    mapping(ProposalType => VoteType) public proposalVoteTypes;

    mapping(uint256 => mapping(address => bool)) public voted;

    enum ProposalType {
        MINT,
        BURN,
        CALL,
        GOV
    }

    enum VoteType {
        SIMPLE_MAJORITY,
        SIMPLE_MAJORITY_QUORUM_REQUIRED,
        SUPERMAJORITY,
        SUPERMAJORITY_QUORUM_REQUIRED
    }

    struct Proposal {
        ProposalType proposalType;
        string description;
        address[] account; // member(s) being added/kicked; account(s) receiving payload
        uint256[] amount; // value(s) to be minted/burned/spent; gov setting(s)
        bytes[] payload; // data for CALL proposals
        uint256 yesVotes;
        uint256 noVotes;
        uint256 creationTime;
    }

    /*///////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    /**
    * @notice Deploys a new DAO instance.
    * @dev constructor to deploy DAO
    * @param name_ Name of the DAO token.
    * @param symbol_ Symbol of the DAO token.
    * @param paused_ bool to indicate if DAO token transfers are paused.
    * @param voters ordered list of addresses that can vote on DAO decisions, to be minted initial tokens
    * @param shares ordered list of token amounts to be minted for each voter in the voters list, respectively
    * @param votingPeriod_ uint256 number of seconds to wait before a proposal can be checked and executed.
    * @param quorum_ uint256 minimum number of individuals required for a proposal to pass with quorum
    * @param supermajority_ uint256 number of individuals required for a proposal to pass at some specified threshold higher than one half
    */  
    constructor(
        string memory name_,
        string memory symbol_,
        bool paused_,
        address[] memory voters,
        uint256[] memory shares,
        uint256 votingPeriod_,
        uint256 quorum_,
        uint256 supermajority_
    )
        LiteDAOtoken(
            name_,
            symbol_,
            paused_,
            voters,
            shares
        )

    {
        require(votingPeriod_ <= 365 days, 'VOTING_PERIOD_MAX');

        require(quorum_ <= 100, 'QUORUM_MAX');

        require(supermajority_ <= 100, 'SUPERMAJORITY_MAX');

        votingPeriod = votingPeriod_;

        quorum = quorum_;

        supermajority = supermajority_;
    }
    /**
    * @notice set the vote types used for each of the proposals
    * @dev external pure function can select from SIMPLE_MAJORITY, SIMPLE_MAJORITY_QUORUM_REQUIRED, SUPERMAJORITY, SUPERMAJORITY_QUORUM_REQUIRED
    * @param mint uint8 representing the vote type for minting
    * @param burn uint8 representing the vote type for burning
    * @param call uint8 representing the vote type for calling
    * @param gov  uint8 representing the vote type for governing
    */
    function setVoteTypes(
        uint8 mint,
        uint8 burn,
        uint8 call,
        uint8 gov
    ) external {
        require(!initialized, 'INITIALIZED');

        proposalVoteTypes[ProposalType.MINT] = VoteType(mint);

        proposalVoteTypes[ProposalType.BURN] = VoteType(burn);

        proposalVoteTypes[ProposalType.CALL] = VoteType(call);

        proposalVoteTypes[ProposalType.GOV] = VoteType(gov);

        initialized = true;
    }

    /*///////////////////////////////////////////////////////////////
                         PROPOSAL LOGIC
    //////////////////////////////////////////////////////////////*/

    modifier onlyTokenHolders() {
        require(balanceOf[msg.sender] > 0, 'NOT_TOKEN_HOLDER');
        _;
    }
  
    /**
    * @notice Creates a new proposal if sender is a token holder
    * @dev external payable function, account variable is used in different contexts depending on proposal type
    * @param proposalType index of ProposalType enum for the proposal 
    * @param description string description of the proposal stored in calldata
    * @param account smartcontract or user address to execute proposal context against: MINT to account, BURN from account, CALL from contract
    * @param amount uint256 amount of the asset to be minted/burned/spent
    * @param payload bytes stored in calldata to be passed to the proposal account context for CALL proposals
    */
    function propose(
        ProposalType proposalType,
        string calldata description,
        address[] calldata account,
        uint256[] calldata amount,
        bytes[] calldata payload
    ) external onlyTokenHolders {
        require(account.length == amount.length && amount.length == payload.length, 'NO_ARRAY_PARITY');

        require(payload.length <= 10, 'ARRAY_MAX');

        if (proposalType == ProposalType.GOV) {
            require(amount[0] <= 365 days, 'VOTING_PERIOD_MAX');

            require(amount[1] <= 100, 'QUORUM_MAX');

            require(amount[2] <= 100, 'SUPERMAJORITY_MAX');
        }

        uint256 proposal = proposalCount;

        proposals[proposal] = Proposal({
            proposalType: proposalType,
            description: description,
            account: account,
            amount: amount,
            payload: payload,
            yesVotes: 0,
            noVotes: 0,
            creationTime: block.timestamp
        });

        // this is reasonably safe from overflow because incrementing `proposalCount` beyond
        // 'type(uint256).max' is exceedingly unlikely compared to optimization benefits
        unchecked {
            proposalCount++;
        }

        emit NewProposal(proposal);
    }

   
    /**
    * @notice Casts a yes/no vote on a proposal if sender is a token holder
    * @dev external function, requires balance of sender to be greater than 0
    * @param proposal uint256 index of the proposal to vote on
    * @param approve bool true for yes, false for no
    */ 
    function vote(uint256 proposal, bool approve) external onlyTokenHolders {
        require(!voted[proposal][msg.sender], 'ALREADY_VOTED');

        Proposal storage prop = proposals[proposal];

        // this is safe from overflow because `votingPeriod` is capped so it will not combine
        // with unix time to exceed 'type(uint256).max'
        unchecked {
            require(block.timestamp <= prop.creationTime + votingPeriod, 'VOTING_ENDED');
        }

        uint256 weight = getPriorVotes(msg.sender, prop.creationTime);

        // this is safe from overflow because `yesVotes` and `noVotes` are capped by `totalSupply`
        // which is checked for overflow in `LiteDAOtoken` contract
        unchecked {
            if (approve) {
                prop.yesVotes += weight;
            } else {
                prop.noVotes += weight;
            }
        }

        voted[proposal][msg.sender] = true;

        emit VoteCast(msg.sender, proposal, approve);
    }

    /**
    * @notice checks if a proposal has passed the VoteType requirements for it to be executed and is executed if so
    * @dev external function, can be called by anyone
    * @param proposal uint256 index of the proposal to check and execute
    */
    function processProposal(uint256 proposal) external {
        Proposal storage prop = proposals[proposal];

        VoteType voteType = proposalVoteTypes[prop.proposalType];

        unchecked {
         require(block.timestamp > prop.creationTime + votingPeriod, 'VOTING_NOT_ENDED');
        }

        bool didProposalPass = _countVotes(voteType, prop.yesVotes, prop.noVotes);

        // this is reasonably safe from overflow because incrementing `i` loop beyond
        // 'type(uint256).max' is exceedingly unlikely compared to optimization benefits
        if (didProposalPass) {
            unchecked {
                if (prop.proposalType == ProposalType.MINT) {
                    for (uint256 i; i < prop.account.length; i++) {
                        _mint(prop.account[i], prop.amount[i]);
                    }
                }

                if (prop.proposalType == ProposalType.BURN) {
                    for (uint256 i; i < prop.account.length; i++) {
                        _burn(prop.account[i], prop.amount[i]);
                    }
                }

                if (prop.proposalType == ProposalType.CALL) {
                    for (uint256 i; i < prop.account.length; i++) {
                        prop.account[i].call{value: prop.amount[i]}(prop.payload[i]);
                    }
                }

                if (prop.proposalType == ProposalType.GOV) {
                    if (prop.amount[0] > 0) votingPeriod = prop.amount[0];
                    if (prop.amount[1] > 0) quorum = prop.amount[1];
                    if (prop.amount[2] > 0) supermajority = prop.amount[2];
                    if (prop.amount[3] > 0) _togglePause();
                }
            }
        }

        delete proposals[proposal];

        emit ProposalProcessed(proposal);
    }

    /**
    * @notice Helper function used to count the number of votes for a proposal depending on the vote type
    * @dev internal view function, one of SIMPLE_MAJORITY, SIMPLE_MAJORITY_QUORUM_REQUIRED, SUPERMAJORITY, SUPERMAJORITY_QUORUM_REQUIRED
    * @param voteType VoteType enum value for the proposal
    * @param yesVotes uint256 number of yes votes
    * @param noVotes uint256 number of no votes
    * @return didProposalPass bool, true if proposal passed the vote type requirements, false if not
    */ 
    function _countVotes(
        VoteType voteType,
        uint256 yesVotes,
        uint256 noVotes
    ) internal view returns (bool didProposalPass) {
        // rule out any failed quorums
        if (voteType == VoteType.SIMPLE_MAJORITY_QUORUM_REQUIRED || voteType == VoteType.SUPERMAJORITY_QUORUM_REQUIRED) {
            uint256 minVotes = (totalSupply * quorum) / 100;

            // this is safe from overflow because `yesVotes` and `noVotes` are capped by `totalSupply`
            // which is checked for overflow in `LiteDAOtoken` contract
            unchecked {
                uint256 votes = yesVotes + noVotes;

                require(votes >= minVotes, 'QUORUM_REQUIRED');
            }
        }

        // simple majority
        if (voteType == VoteType.SIMPLE_MAJORITY || voteType == VoteType.SIMPLE_MAJORITY_QUORUM_REQUIRED) {
            if (yesVotes > noVotes) {
                didProposalPass = true;
            }
        }

        // supermajority
        if (voteType == VoteType.SUPERMAJORITY || voteType == VoteType.SUPERMAJORITY_QUORUM_REQUIRED) {
            // example: 7 yes, 2 no, supermajority = 66
            // ((7+2) * 66) / 100 = 5.94; 7 yes will pass
            uint256 minYes = ((yesVotes + noVotes) * supermajority) / 100;

            if (yesVotes >= minYes) {
                didProposalPass = true;
            }
        }
    }
}
