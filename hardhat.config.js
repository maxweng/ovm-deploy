/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('@eth-optimism/hardhat-ovm')
require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require("hardhat-gas-reporter");
require("solidity-coverage");

module.exports = {
  networks: {
    hardhat: {
      accounts: {
        mnemonic: 'test test test test test test test test test test test junk'
      }
    },
    // Add this network to your config!
    optimism: {
      url: 'http://127.0.0.1:8545',
      accounts: {
        mnemonic: 'test test test test test test test test test test test junk'
      },
      gasPrice: 0,
      ovm: true
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          },
          evmVersion: "istanbul"
        }
      }
    ]
  },
  ovm: {
    solcVersion: '0.5.16'
  },
  paths: {
    sources: "./contracts",
    tests: "./test-hardhat",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 100
  }
};
