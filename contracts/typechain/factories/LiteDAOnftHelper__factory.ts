/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  LiteDAOnftHelper,
  LiteDAOnftHelperInterface,
} from "../LiteDAOnftHelper";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC1155Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "sig",
        type: "bytes4",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC721Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "sig",
        type: "bytes4",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b5061022b806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c8063150b7a021461003b578063f23a6e6114610064575b600080fd5b61004e6100493660046100fd565b610077565b60405161005b91906101e0565b60405180910390f35b61004e61007236600461016a565b610088565b50630a85bd0160e11b949350505050565b5063f23a6e6160e01b95945050505050565b80356001600160a01b03811681146100b157600080fd5b919050565b60008083601f8401126100c7578182fd5b50813567ffffffffffffffff8111156100de578182fd5b6020830191508360208285010111156100f657600080fd5b9250929050565b600080600080600060808688031215610114578081fd5b61011d8661009a565b945061012b6020870161009a565b935060408601359250606086013567ffffffffffffffff81111561014d578182fd5b610159888289016100b6565b969995985093965092949392505050565b60008060008060008060a08789031215610182578081fd5b61018b8761009a565b95506101996020880161009a565b94506040870135935060608701359250608087013567ffffffffffffffff8111156101c2578182fd5b6101ce89828a016100b6565b979a9699509497509295939492505050565b6001600160e01b03199190911681526020019056fea2646970667358221220b6a896c8f163c0e1d43e40ea1c813f6f3e8f094f9c752c69c41c10e7076a3c1064736f6c63430008000033";

export class LiteDAOnftHelper__factory extends ContractFactory {
  constructor(
    ...args: [signer: Signer] | ConstructorParameters<typeof ContractFactory>
  ) {
    if (args.length === 1) {
      super(_abi, _bytecode, args[0]);
    } else {
      super(...args);
    }
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<LiteDAOnftHelper> {
    return super.deploy(overrides || {}) as Promise<LiteDAOnftHelper>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): LiteDAOnftHelper {
    return super.attach(address) as LiteDAOnftHelper;
  }
  connect(signer: Signer): LiteDAOnftHelper__factory {
    return super.connect(signer) as LiteDAOnftHelper__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): LiteDAOnftHelperInterface {
    return new utils.Interface(_abi) as LiteDAOnftHelperInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): LiteDAOnftHelper {
    return new Contract(address, _abi, signerOrProvider) as LiteDAOnftHelper;
  }
}
