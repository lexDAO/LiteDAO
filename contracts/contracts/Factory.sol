// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.0;

import './LiteDAO.sol';

/// @notice Factory to deploy LiteDAO.
contract LiteDAOfactory {
    event DAOdeployed(address indexed liteDAO);
    
    address[] public daoRegistry;

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
