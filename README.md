<H1> GolfDAO NFT Repo </H1>

### <H2> Mumbai </H2>

  SimpleDAPP on Mumbai: https://oneclickdapp.com/samuel-change
  
  Polygon Mumbai Proxy Deployment: https://mumbai.polygonscan.com/address/0xd370E6d057B4265D05fd673123139bc46b03a3Ee
  
  Polygon Mumbai Implementation Deployment: https://mumbai.polygonscan.com/address/0x461e17e0cd1c36b62b319d0913665896d049eb66#code
  
  OpenSea Mumbai Test Shop: https://testnets.opensea.io/collection/golfdao-sfnagxod7r

&nbsp;


### <H2> Mainnet </H2>
  SimpleDAPP on Mainet: https://oneclickdapp.com/griffin-romeo

  Polygon Mainet Proxy Deployment: https://polygonscan.com/address/0x2fBE590F96D9Dbc46299ee809862338F70f23e25

  Polygon Mainet Implementation Deployment: https://polygonscan.com/address/0x533bA2D9291ff2a53Aac0a5edbdA6ca5f0969184

&nbsp;


### <H2> Info </H2>
  
  UUPS proxy pattern for ERC721 upgradable contract deployment. Gas optimized, URI's are updateable post mint, Optional Access Controls and roles (say, for minting only permissions, for "members") can be easily added.
  
  Upgrades must me done via Hardat using the OpenZeppelin Hardhat-Upgrades plugin. Can also be configured for Truffle deployment. Remix is NOT SUPPORTED.   https://docs.openzeppelin.com/upgrades-plugins/1.x/api-hardhat-upgrades

  
  Updated Implementation must respect EVM storage structures and variables should not be modified. New features on upgrades can only be APPENDED. Failure to comply will result in messed up storage mapping and will result in collisions. https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
  
  Integration with frontend Dapps will require ***msg.value*** to be appended that meets the contract fixed token price of 700 ether, though since this is on Matic the rough equivalent of 0.3 real ether is the goal. Updating the minting cost can be achieved post deployment of implementation.
  
  Contract will withhold recieved payments from NFT sales and is setup to payout to 2 fixed addresses. These payouts must be executed manually by the contract owner which can be a separate address. To change the payout settings the implementation must be upgraded.
  
  &nbsp;
  
  
  ### <H2> Disclaimer </H2> 
  
  I am not liable for forks or the usage of this code in inproper ways and without prior written agreement. Code has been tested and built on industry standards. Use at your own risk.
  
  MIT License.


