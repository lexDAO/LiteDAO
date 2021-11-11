import { BigInt , log} from "@graphprotocol/graph-ts"

import {
  LiteDAO,
  Approval,
  DelegateChanged,
  DelegateVotesChanged,
  NewProposal,
  ProposalProcessed,
  TogglePause,
  Transfer,
  VoteCast
} from "../generated/LiteDAO/LiteDAO"
import { ExampleEntity } from "../generated/schema"

export function handleApproval(event: Approval): void {
  // Entities can be loaded from the store using a string ID; this ID
  // needs to be unique across all entities of the same type
  let entity = ExampleEntity.load(event.transaction.from.toHex())

  // Entities only exist after they have been saved to the store;
  // `null` checks allow to create entities on demand
  if (entity == null) {
    entity = new ExampleEntity(event.transaction.from.toHex())

    // Entity fields can be set using simple assignments
    entity.count = BigInt.fromI32(0)
  }

  // BigInt and BigDecimal math are supported
  entity.count = entity.count.plus(BigInt.fromI32(1))

  // Entity fields can be set based on event parameters
  entity.owner = event.params.owner
  entity.spender = event.params.spender

  // Entities can be written to the store with `.save()`
  entity.save()

  // Note: If a handler doesn't require existing field values, it is faster
  // _not_ to load the entity from the store. Instead, create it fresh with
  // `new Entity(...)`, set the fields that should be updated and save the
  // entity back to the store. Fields that were not set or unset remain
  // unchanged, allowing for partial updates to be applied.

  // It is also possible to access smart contracts from mappings. For
  // example, the contract that has emitted the event can be connected to
  // with:
  //
  // let contract = Contract.bind(event.address)
  //
  // The following functions can then be called on this contract to access
  // state variables and other data:
  //
  // - contract.DELEGATION_TYPEHASH(...)
  // - contract.DOMAIN_SEPARATOR(...)
  // - contract.PERMIT_TYPEHASH(...)
  // - contract.allowance(...)
  // - contract.approve(...)
  // - contract.balanceOf(...)
  // - contract.checkpoints(...)
  // - contract.decimals(...)
  // - contract.delegates(...)
  // - contract.getCurrentVotes(...)
  // - contract.getPriorVotes(...)
  // - contract.name(...)
  // - contract.nonces(...)
  // - contract.numCheckpoints(...)
  // - contract.onERC1155Received(...)
  // - contract.onERC721Received(...)
  // - contract.paused(...)
  // - contract.processProposal(...)
  // - contract.proposalCount(...)
  // - contract.proposalVoteTypes(...)
  // - contract.proposals(...)
  // - contract.quorum(...)
  // - contract.supermajority(...)
  // - contract.symbol(...)
  // - contract.totalSupply(...)
  // - contract.transfer(...)
  // - contract.transferFrom(...)
  // - contract.voted(...)
  // - contract.votingPeriod(...)
}

export function handleDelegateChanged(event: DelegateChanged): void {
  log.info(event.address.toHexString(),[])
}

export function handleDelegateVotesChanged(event: DelegateVotesChanged): void {
  log.info(event.address.toHexString(),[])
}

export function handleNewProposal(event: NewProposal): void {
  log.info(event.address.toHexString(),[])
}

export function handleProposalProcessed(event: ProposalProcessed): void {
  log.info(event.address.toHexString(),[])
}

export function handleTogglePause(event: TogglePause): void {
  log.info(event.address.toHexString(),[])
}

export function handleTransfer(event: Transfer): void {
  log.info(event.address.toHexString(),[])
}

export function handleVoteCast(event: VoteCast): void {
  log.info(event.address.toHexString(),[])
}
