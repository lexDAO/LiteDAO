// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.0;

import './LiteDAO.sol';

/// @notice Factory to deploy LiteDAO.
contract LiteDAOfactory {
    event DAOdeployed(address indexed liteDAO);
    
    address[] public daoRegistry;
    /**
    * @notice Deploys a new DAO instance.
    * @dev external function can be called by anyone to specify settings for a new DAO.
    * @param name_ Name of the DAO token.
    * @param symbol_ Symbol of the DAO token.
    * @param paused_ bool to indicate if DAO token transfers are paused.
    * @param voters ordered list of addresses that can vote on DAO decisions, to be minted initial tokens
    * @param shares ordered list of token amounts to be minted for each voter in the voters list, respectively
    * @param votingPeriod_ uint256 number of seconds to wait before a proposal can be checked and executed.
    * @param quorum_ uint256 minimum number of individuals required for a proposal to pass with quorum
    * @param supermajority_ uint256 number of individuals required for a proposal to pass at some specified threshold higher than one half
    * @param mint uint8 representing the vote type for minting proposals
    * @param burn uint8 representing the vote type for burning proposals
    * @param call uint8 representing the vote type for calling proposals
    * @param gov  uint8 representing the vote type for governing proposals
    * @return liteDAO address of the new DAO
    */  
    function deployDAO(
        string memory name_,
        string memory symbol_,
        bool paused_,
        address[] memory voters,
        uint256[] memory shares,
        uint256 votingPeriod_,
        uint256 quorum_,
        uint256 supermajority_,
        uint8 mint,
        uint8 burn,
        uint8 call,
        uint8 gov
      ) external returns (LiteDAO liteDAO) {
        liteDAO = new LiteDAO(name_, symbol_, paused_, voters, shares, votingPeriod_, quorum_, supermajority_);
        
        liteDAO.setVoteTypes(mint, burn, call, gov);
        
        daoRegistry.push(address(liteDAO));
        
        emit DAOdeployed(address(liteDAO));
    }
}
