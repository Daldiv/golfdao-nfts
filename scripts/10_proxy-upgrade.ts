export {}
const { ethers, upgrades } = require("hardhat");

async function main() {
  const GolfV2 = await ethers.getContractFactory("GolfV2");
  const golf = await upgrades.upgradeProxy(GOLF_ADDRESS, GolfV2);
  console.log("GolfNFT's upgraded");
}

main();
