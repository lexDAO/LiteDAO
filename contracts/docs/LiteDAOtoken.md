# LiteDAO Token
Modern and gas efficient ERC20 + EIP-2612 implementation with COMP-style governance,



## Functions


### getCurrentVotes
```solidity
  function getCurrentVotes(
    address account
  ) external returns (uint256 votes)
```
get the current votes delegated to an account

external view function

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`account` | address | address, the account to get the vote weight for

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`votes`| address | uint256 delegated to the account
### delegate
```solidity
  function delegate(
    address delegatee
  ) external
```
Delegate a vote to a delegatee

external function writes new checkpoint to storage

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`delegatee` | address | address of delegatee

### delegateBySig
```solidity
  function delegateBySig(
  ) external
```




### getPriorVotes
```solidity
  function getPriorVotes(
    address account,
    uint256 timestamp
  ) public returns (uint256 votes)
```
gets the prior votes delegated to an account at a given checkpoint

public view function, returns votes at checkpoint nearest to timestamp

#### Parameters:
| Name | Type | Description                                                          |
| :--- | :--- | :------------------------------------------------------------------- |
|`account` | address | address of account to get prior votes for
|`timestamp` | uint256 | timestamp to get prior votes for

#### Return Values:
| Name                           | Type          | Description                                                                  |
| :----------------------------- | :------------ | :--------------------------------------------------------------------------- |
|`votes`| address | uint256 number of votes for account
### _delegate
```solidity
  function _delegate(
  ) internal
```




### _moveDelegates
```solidity
  function _moveDelegates(
  ) internal
```




### _writeCheckpoint
```solidity
  function _writeCheckpoint(
  ) internal
```




### _computeDomainSeparator
```solidity
  function _computeDomainSeparator(
  ) internal returns (bytes32 domainSeparator)
```




### DOMAIN_SEPARATOR
```solidity
  function DOMAIN_SEPARATOR(
  ) public returns (bytes32 domainSeparator)
```




### permit
```solidity
  function permit(
  ) external
```




### _mint
```solidity
  function _mint(
  ) internal
```




### _burn
```solidity
  function _burn(
  ) internal
```




### _togglePause
```solidity
  function _togglePause(
  ) internal
```




### safeCastTo32
```solidity
  function safeCastTo32(
  ) internal returns (uint32 y)
```




### safeCastTo224
```solidity
  function safeCastTo224(
  ) internal returns (uint224 y)
```




## Events
### Transfer
```solidity
  event Transfer(
  )
```



### Approval
```solidity
  event Approval(
  )
```



### DelegateChanged
```solidity
  event DelegateChanged(
  )
```



### DelegateVotesChanged
```solidity
  event DelegateVotesChanged(
  )
```



### TogglePause
```solidity
  event TogglePause(
  )
```

### constructor
```solidity
  function constructor(
  ) public
```




### approve
```solidity
  function approve(
  ) external returns (bool)
```




### transfer
```solidity
  function transfer(
  ) external returns (bool)
```




### transferFrom
```solidity
  function transferFrom(
  ) external returns (bool)
```

