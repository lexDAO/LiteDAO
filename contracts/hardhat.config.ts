import dotenv from 'dotenv'

import { HardhatUserConfig, task } from 'hardhat/config'
import 'hardhat-contract-sizer';
import 'hardhat-abi-exporter';
import '@typechain/hardhat';
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'
import '@nomiclabs/hardhat-ganache'



dotenv.config()


const GAS_LIMIT = 20000000
const WALLET_MNEMONIC = process.env.WALLET_MNEMONIC || '';

const config: HardhatUserConfig = {
  networks: {
    hardhat: {
      gas: GAS_LIMIT,
      blockGasLimit: GAS_LIMIT,
      accounts: { mnemonic: WALLET_MNEMONIC },
    },
    localhost: {
      url: 'http://127.0.0.1:8545',
      timeout: 60000,
      gas: GAS_LIMIT,
      blockGasLimit: GAS_LIMIT,
      accounts: { mnemonic: WALLET_MNEMONIC },
    },
    ganache: {
      // Workaround for https://github.com/nomiclabs/hardhat/issues/518
      url: 'http://127.0.0.1:8555',
      gasLimit: GAS_LIMIT,
    } as any,
    rinkeby: {
      url: process.env.RINKEBY_JSONRPC_HTTP_URL || 'http://127.0.0.1:8545',
      accounts: { mnemonic: WALLET_MNEMONIC },
    },
    xdai: {
      url: process.env.XDAI_JSONRPC_HTTP_URL || 'https://rpc.xdaichain.com',
      timeout: 60000,
      accounts: { mnemonic: WALLET_MNEMONIC },
    },
  },
  paths: {
    artifacts: 'build/contracts',
    tests: 'tests',
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  solidity: {
    version: '0.8.0',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  
};

task('compile', 'Compiles the entire project, building all artifacts', async (_, { config }, runSuper) => {
  await runSuper();
});

export default config
