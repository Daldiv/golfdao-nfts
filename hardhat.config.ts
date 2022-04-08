import fs from 'fs';
import * as dotenv from 'dotenv';
import { HardhatUserConfig, task } from 'hardhat/config';
import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import CollectionConfig from './config/CollectionConfig';
import '@openzeppelin/hardhat-upgrades';

dotenv.config();

require("@nomiclabs/hardhat-ganache");
require('@openzeppelin/hardhat-upgrades');

/*
 * If you have issues with stuck transactions or you simply want to invest in
 * higher gas fees in order to make sure your transactions will run smoother
 * and faster, then you can update the followind value.
 * This value is used by default in any network defined in this project, but
 * please make sure to add it manually if you define any custom network.
 * 
 * Example:
 * Setting the value to "1.1" will raise the gas values by 10% compared to the
 * estimated value.
 */
const DEFAULT_GAS_MULTIPLIER: number = 1.5;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html

/* task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task('generate-root-hash', 'Generates and prints out the root hash for the current whitelist', async () => {
  // Check configuration
  if (CollectionConfig.whitelistAddresses.length < 1) {
    throw 'The whitelist is empty, please add some addresses to the configuration.';
  }

  // Build the Merkle Tree
  const leafNodes = CollectionConfig.whitelistAddresses.map(addr => keccak256(addr));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
  const rootHash = '0x' + merkleTree.getRoot().toString('hex');

  console.log('The Merkle Tree root hash for the current whitelist is: ' + rootHash);
});

task('generate-proof', 'Generates and prints out the whitelist proof for the given address (compatible with block explorers such as Etherscan)', async (taskArgs: {address: string}) => {
  // Check configuration
  if (CollectionConfig.whitelistAddresses.length < 1) {
    throw 'The whitelist is empty, please add some addresses to the configuration.';
  }

  // Build the Merkle Tree
  const leafNodes = CollectionConfig.whitelistAddresses.map(addr => keccak256(addr));
  const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
  const proof = merkleTree.getHexProof(keccak256(taskArgs.address)).toString().replace(/'/g, '').replace(/ /g, '');

  console.log('The whitelist proof for the given address is: ' + proof);
})
.addPositionalParam('address', 'The public address');

task('rename-contract', 'Renames the smart contract replacing all occurrences in source files', async (taskArgs: {newName: string}, hre) => {
  // Validate new name
  if (!/^([A-Z][A-Za-z0-9]+)$/.test(taskArgs.newName)) {
    throw 'The contract name must be in PascalCase: https://en.wikipedia.org/wiki/Camel_case#Variations_and_synonyms';
  }

  const oldContractFile = `${__dirname}/contracts/${CollectionConfig.contractName}.sol`;
  const newContractFile = `${__dirname}/contracts/${taskArgs.newName}.sol`;

  if (!fs.existsSync(oldContractFile)) {
    throw `Contract file not found: "${oldContractFile}" (did you change the configuration manually?)`;
  }

  if (fs.existsSync(newContractFile)) {
    throw `A file with that name already exists: "${oldContractFile}"`;
  }

  // Replace names in source files
  replaceInFile(__dirname + '/../minting-dapp/src/scripts/lib/NftContractType.ts', CollectionConfig.contractName, taskArgs.newName);
  replaceInFile(__dirname + '/config/CollectionConfig.ts', CollectionConfig.contractName, taskArgs.newName);
  replaceInFile(__dirname + '/lib/NftContractProvider.ts', CollectionConfig.contractName, taskArgs.newName);
  replaceInFile(oldContractFile, CollectionConfig.contractName, taskArgs.newName);

  // Rename the contract file
  fs.renameSync(oldContractFile, newContractFile);

  console.log(`Contract renamed successfully from "${CollectionConfig.contractName}" to "${taskArgs.newName}"!`);

  // Rebuilding types
  await hre.run('typechain');
})
.addPositionalParam('newName', 'The new name');

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

*/

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.9',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    localhost: {
      url: 'http://localhost:8545/rpc',
      timeout: 600000,
      gasPrice: 900000000,
			gas: 21000000,
			accounts: [ '0x8166f546bab6da521a8369cab06c5d2b9e46670292d85c875ee9ec20e84ffb61' ],
    },
  },

/** gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: 'USD',
    coinmarketcap: process.env.GAS_REPORTER_COIN_MARKET_CAP_API_KEY,
  */
	};
/*  etherscan: {
    apiKey: {
      // Ethereum
      rinkeby: process.env.BLOCK_EXPLORER_API_KEY,
      mainnet: process.env.BLOCK_EXPLORER_API_KEY,

      // Polygon
      polygon: process.env.BLOCK_EXPLORER_API_KEY,
      polygonMumbai: process.env.BLOCK_EXPLORER_API_KEY,
    },
  },
};*/

// Setup "testnet" network
if (process.env.NETWORK_TESTNET_URL !== undefined) {
  config.networks!.testnet = {
    url: process.env.NETWORK_TESTNET_URL,
    timeout: 0,
		accounts: [process.env.NETWORK_TESTNET_PRIVATE_KEY!],
    gasPrice: 53000000000,
    gas: 6000000,
  };
}

// Setup "mainnet" network
if (process.env.NETWORK_MAINNET_URL !== undefined) {
  config.networks!.mainnet = {
    url: process.env.NETWORK_MAINNET_URL,
    timeout: 6000000,
		accounts: [process.env.NETWORK_MAINNET_PRIVATE_KEY!],
    gasMultiplier: DEFAULT_GAS_MULTIPLIER,
		gasPrice: 900000000,
    gas: 81000000,

  };
}

export default config;

/**
 * Replaces all occurrences of a string in the given file. 

function replaceInFile(file: string, search: string, replace: string): void
{
  const fileContent = fs.readFileSync(file, 'utf8').replace(new RegExp(search, 'g'), replace);

  fs.writeFileSync(file, fileContent, 'utf8');
}*/ 
