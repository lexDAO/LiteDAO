# LiteDAO Factory
Factory to deploy LiteDAO.


## Functions
### deployDAO
```solidity
  function deployDAO(
    string name_,
    string symbol_,
    bool paused_,
    address[] voters,
    uint256[] shares,
    uint256 votingPeriod_,
    uint256 quorum_,
    uint256 supermajority_,
    uint8 mint,
    uint8 burn,
    uint8 call,
    uint8 gov
  ) external returns (contract LiteDAO liteDAO)
```
Deploys a new DAO instance.

external function can be called by anyone to specify settings for a new DAO.

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
|`mint` | uint8 | uint8 representing the vote type for minting proposals
|`burn` | uint8 | uint8 representing the vote type for burning proposals
|`call` | uint8 | uint8 representing the vote type for calling proposals
|`gov` | uint8 |  uint8 representing the vote type for governing proposals

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`liteDAO`| string | address of the new DAO
## Events
### DAOdeployed
```solidity
  event DAOdeployed(
  )
```



