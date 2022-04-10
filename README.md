##<H1> GolfDAO NFT Repo </H1>

### <H2> Mumbai </H2>
  SimpleDAPP on Mumbai: https://oneclickdapp.com/samuel-change
  
  Polygon Mumbai Proxy Deployment: https://mumbai.polygonscan.com/address/0xd370E6d057B4265D05fd673123139bc46b03a3Ee
  
  Polygon Mumbai Implementation Deployment: https://mumbai.polygonscan.com/address/0x461e17e0cd1c36b62b319d0913665896d049eb66#code
  
  OpenSea Mumbai Test Shop: https://testnets.opensea.io/collection/golfdao-sfnagxod7r


### <H2> Mainnet </H2>
  Polygon Mainet Proxy Deployment: https://polygonscan.com/address/0x2fBE590F96D9Dbc46299ee809862338F70f23e25

  Polygon Mainet Implementation Deployment: https://polygonscan.com/address/0x533bA2D9291ff2a53Aac0a5edbdA6ca5f0969184


### <H2> Info </H2>
  
  UUPS proxy pattern for ERC721 upgradable contract deployment. Gas optimized, URI's are updateable post mint, Optional Access Controls and roles can be easily added.
  
  Upgrades must me done via Hardat using the OpenZeppelin Hardhat-Upgrades plugin. Can also be configured for Truffle deployment. Remix is NOT SUPPORTED.   https://docs.openzeppelin.com/upgrades-plugins/1.x/api-hardhat-upgrades

  
  Updated Implementation must respect EVM storage structures and variables should not be modified. New features on upgrades can only be APPENDED. Failure to comply will result in messed up storage mapping and will result in collisions. https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
  
  MIT License.


