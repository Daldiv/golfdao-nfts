const { ethers, upgrades } = require("hardhat");

async function main() {
  // Deploying
	const [deployer] = await ethers.getSigners();
	console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  
  console.log("Deploying GolfDAO Proxy...")
	const Golf = await ethers.getContractFactory("GolfDAO_VERSION");
  const golf = await upgrades.deployProxy(Golf);
  await golf.deployed();
	console.log("GolfDAO NFTs deployed to:", golf.address);

  // Upgrading
	console.log ("Upgrading GolfDAO")
  const GolfNEW = await ethers.getContractFactory("GolfDAO_VERSION");
  const upgraded = await upgrades.upgradeProxy(instance.address, GolfNEW);
	console.log ("Upgraded GolfDAO to:", GolfNEW.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
