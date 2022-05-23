import '@openzeppelin/hardhat-upgrades';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-ethers';
import '@typechain/hardhat';
import '@openzeppelin/hardhat-upgrades';

const ALCHEMY_API_KEY_MUMBAI = "TEST-KEY";
const ALCHEMY_API_KEY = "ALCHEMY_KEY";
const POLYSCAN_API_KEY = "POLYGONSCAN_KEY";
const PRIVATE_KEY = "WALLET_KEY";

const config = {
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000
      	},
    	},
  },
	networks: {
		localhost: {
      url: 'http://localhost:8545/rpc',
      timeout: 600000,
      gasPrice: 900000000,
      gas: 21000000,
      accounts: [ 'LOCAL_CHAIN_ACCOUNT_PRIVATE_KEY' ],
    },
		mumbai: {
			url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_API_KEY_MUMBAI}`,
			accounts: [`${PRIVATE_KEY}`],
			timeout: 0,
    	gasPrice: 53000000000,
    	gas: 6000000,
			gasLimit: 7000000,
		},
		matic: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${PRIVATE_KEY}`],
      timeout: 0,
      gasPrice: 43000000000,
      gas: 4000000,
    },
	},
  mocha: {
    timeout: 40000,
	},
	etherscan: {
	apiKey: POLYSCAN_API_KEY,
	},
}


export default config

