# LiteDAO
Simple gas-optimized DAO core module.


## Functions
### constructor
```solidity
  function constructor(
    string name_,
    string symbol_,
    bool paused_,
    address[] voters,
    uint256[] shares,
    uint256 votingPeriod_,
    uint256 quorum_,
    uint256 supermajority_
  ) public
```
Deploys a new DAO instance.

constructor to deploy DAO

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`name_` | string | Name of the DAO token.
|`symbol_` | string | Symbol of the DAO token.
|`paused_` | bool | bool to indicate if DAO token transfers are paused.
|`voters` | address[] | ordered list of addresses that can vote on DAO decisions, to be minted initial tokens
|`shares` | uint256[] | ordered list of token amounts to be minted for each voter in the voters list, respectively
|`votingPeriod_` | uint256 | uint256 number of seconds to wait before a proposal can be checked and executed.
|`quorum_` | uint256 | uint256 minimum number of individuals required for a proposal to pass with quorum
|`supermajority_` | uint256 | uint256 number of individuals required for a proposal to pass at some specified threshold higher than one half

### setVoteTypes
```solidity
  function setVoteTypes(
    uint8 mint,
    uint8 burn,
    uint8 call,
    uint8 gov
  ) external
```
set the vote types used for each of the proposals

external pure function can select from SIMPLE_MAJORITY, SIMPLE_MAJORITY_QUORUM_REQUIRED, SUPERMAJORITY, SUPERMAJORITY_QUORUM_REQUIRED

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`mint` | uint8 | uint8 representing the vote type for minting
|`burn` | uint8 | uint8 representing the vote type for burning
|`call` | uint8 | uint8 representing the vote type for calling
|`gov` | uint8 |  uint8 representing the vote type for governing

### propose
```solidity
  function propose(
    enum LiteDAO.ProposalType proposalType,
    string description,
    address account,
    address asset,
    uint256 amount,
    bytes payload
  ) external
```
Creates a new proposal if sender is a token holder

external payable function, account variable is used in different contexts depending on proposal type

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposalType` | enum LiteDAO.ProposalType | index of ProposalType enum for the proposal 
|`description` | string | string description of the proposal stored in calldata
|`account` | address | smartcontract or user address to execute proposal context against: MINT to account, BURN from account, CALL from contract
|`asset` | address | address of the asset to be minted/burned/spent
|`amount` | uint256 | uint256 amount of the asset to be minted/burned/spent
|`payload` | bytes | bytes stored in calldata to be passed to the proposal account context for CALL proposals

### vote
```solidity
  function vote(
    uint256 proposal,
    bool approve
  ) external
```
Casts a yes/no vote on a proposal if sender is a token holder

external function, requires balance of sender to be greater than 0

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposal` | uint256 | uint256 index of the proposal to vote on
|`approve` | bool | bool true for yes, false for no

### processProposal
```solidity
  function processProposal(
    uint256 proposal
  ) external returns (bool success)
```
checks if a proposal has passed the VoteType requirements for it to be executed and is executed if so

external function, can be called by anyone

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`proposal` | uint256 | uint256 index of the proposal to check and execute

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`success`| uint256 | bool, true if proposal passed requirements and was executed successfully, false if not
### _countVotes
```solidity
  function _countVotes(
    enum LiteDAO.VoteType voteType,
    uint256 yesVotes,
    uint256 noVotes
  ) internal returns (bool didProposalPass)
```
Helper function used to count the number of votes for a proposal depending on the vote type

internal view function, one of SIMPLE_MAJORITY, SIMPLE_MAJORITY_QUORUM_REQUIRED, SUPERMAJORITY, SUPERMAJORITY_QUORUM_REQUIRED

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`voteType` | enum LiteDAO.VoteType | VoteType enum value for the proposal
|`yesVotes` | uint256 | uint256 number of yes votes
|`noVotes` | uint256 | uint256 number of no votes

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`didProposalPass`| enum LiteDAO.VoteType | bool, true if proposal passed the vote type requirements, false if not
## Events
### NewProposal
```solidity
  event NewProposal(
  )
```



### VoteCast
```solidity
  event VoteCast(
  )
```



### ProposalProcessed
```solidity
  event ProposalProcessed(
  )
```