export {}
import { ethers } from "hardhat"
import { upgrades } from "hardhat"


async function main() {
	const Golf = await ethers.getContractFactory("GolfDAOV1");
  console.log("Deploying GolfDAO Proxy...")
	const golf = await upgrades.deployProxy(Golf, []);

  await golf.deployed();
  console.log("GolfDAO NFTs deployed to:", golf.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
