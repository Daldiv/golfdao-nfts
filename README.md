<H1> GolfDAO NFT Repo </H1>

### <H2> Mumbai </H2>

  SimpleDAPP on Mumbai: https://oneclickdapp.com/tower-glass
  
  Polygon Mumbai Proxy Deployment: https://mumbai.polygonscan.com/address/0x74ba324356241741a936f5c86769c28550808d1d
  
  Polygon Mumbai Implementation Deployment: https://mumbai.polygonscan.com/address/0xc62ff53a59181b10b046e6ab049b8186232056dd
  
  OpenSea Mumbai Test Shop: https://testnets.opensea.io/collection/golfdao-sfnagxod7r

&nbsp;


### <H2> Mainnet </H2>
  SimpleDAPP on Mainet: https://oneclickdapp.com/papa-solar

  Polygon Mainet Proxy Deployment: https://polygonscan.com/address/0x2fBE590F96D9Dbc46299ee809862338F70f23e25

  Polygon Mainet Implementation Deployment: https://polygonscan.com/address/0xd56abb64fde199d2d04237984449da3c80c91437

&nbsp;


### <H2> Info </H2>
  
  UUPS proxy pattern for ERC721 upgradable contract deployment. Gas optimized, URI's are updateable post mint, Optional Access Controls and roles (say, for minting only permissions, for "members") can be easily added.
  
  Upgrades must me done via Hardat using the OpenZeppelin Hardhat-Upgrades plugin. Can also be configured for Truffle deployment. Remix is NOT SUPPORTED.   https://docs.openzeppelin.com/upgrades-plugins/1.x/api-hardhat-upgrades

  
  Updated Implementation must respect EVM storage structures and variables should not be modified. New features on upgrades can only be APPENDED. Failure to comply will result in messed up storage mapping and will result in collisions. https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
  
  Integration with frontend Dapps will require ***msg.value*** to be appended that meets the contract fixed token price of 700 ether, though since this is on Matic the rough equivalent of 0.3 real ether is the goal. Updating the minting cost can be achieved post deployment of implementation.
  
  Contract will withhold recieved payments from NFT sales and is setup to payout to 2 fixed addresses. These payouts must be executed manually by the contract owner which can be a separate address. To change the payout settings the implementation must be upgraded.
  
  Batch minting has been added, though minting more than 30 in a single transaction usually hits the gas limit!
  
  &nbsp;
  
  
  ### <H2> Disclaimer </H2> 
  
  I am not liable for forks or the usage of this code in inproper ways and without prior written agreement. Code has been tested and built on industry standards. Use at your own risk.
  
  MIT License.


