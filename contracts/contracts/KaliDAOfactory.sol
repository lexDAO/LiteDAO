// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.8.0;

import './KaliDAO.sol';

/// @notice Factory to deploy KaliDAO.
contract KaliDAOfactory {
    event DAOdeployed(address indexed kaliDAO);
    
    address[] public daoRegistry;

    function deployKaliDAO(
        string memory name_,
        string memory symbol_,
        bool paused_,
        address[] memory voters_,
        uint256[] memory shares_,
        uint256 votingPeriod_,
        uint256 quorum_,
        uint256 supermajority_,
        uint8 mint_,
        uint8 burn_,
        uint8 call_,
        uint8 gov_
      ) external returns (KaliDAO kaliDAO) {
        kaliDAO = new KaliDAO(name_, symbol_, paused_, voters_, shares_, votingPeriod_, quorum_, supermajority_);
        
        kaliDAO.setVoteTypes(mint_, burn_, call_, gov_);
        
        daoRegistry.push(address(kaliDAO));
        
        emit DAOdeployed(address(kaliDAO));
    }
}
