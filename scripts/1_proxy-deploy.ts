import { ethers } from "hardhat"
import { upgrades } from "hardhat"

async function main() {
	const [deployer] = await ethers.getSigners();

	console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

	const Golf = await ethers.getContractFactory("GolfDAO_V2");
  console.log("Deploying GolfDAO Proxy...")
	const golf = await upgrades.deployProxy(Golf, [] );

  await golf.deployed();
  console.log("GolfDAO NFTs deployed to:", golf.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
