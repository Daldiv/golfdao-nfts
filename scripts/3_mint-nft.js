// @ts-ignore
require('dotenv').config();
const API_URL = process.env.API_URL;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const DESTINATION_ADDRESS = process.env.DESTINATION_ADDRESS;
const CONTRACT_ADRESS = process.env.CONTRACT_ADDRESS;
const AMOUNT = process.env.AMOUNTI;
const METADATA_URL = process.env.METADATA_URL;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const contract = require("../artifacts/contracts/GolfDAO_V2.sol/GolfDAO_V2.json");
const contractAddress = CONTRACT_ADDRESS;

const nftContract = new web3.eth.Contract(contract.abi, contractAddress);

	async function mintNFT(to, uri, amount) {
		const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest');
	
		const tx = {
			'from': PUBLIC_KEY,
			'to': contractAddress,
			'nonce': nonce,
			'gas': 500000,
			'maxPriorityFeePerGas': 2999999987,
			'data': nftContract.methods.safeMint(to, uri, amount).encodeABI()
		};

		const signedTx = await web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
		const transactionReceipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

		console.log(`Transaction receipt: ${JSON.stringify(transactionReceipt)}`);
}

mintNFT(DESTINATION_ADDRESS , METADATA_URL , AMOUNT);

