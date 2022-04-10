import '@openzeppelin/hardhat-upgrades';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-ethers';
import '@typechain/hardhat';
import '@openzeppelin/hardhat-upgrades';

const ALCHEMY_API_KEY_MUMBAI = "7OXBPa2dwoP5c5AOKqzs1W6XPym6n6-C";
const ALCHEMY_API_KEY = "HtQpsG4hC9hbT_Kw825G4_Elv5-TjBay";
const POLYSCAN_API_KEY = "JY3WFIA8YTPJPPMZS1MQM24DATGJ5YZSC4";
const PRIVATE_KEY = "c749bf5c4a61412046eebf27be29c50a738ade48f7e20cf9465e2bfb2f1af5da";

const config = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
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

