// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// ███████╗ █████╗ ███╗   ██╗██████╗ ███████╗███████╗ ███████╗
// ██╔════╝██╔══██╗████╗  ██║██╔══██╗██╔════╝██╔══██║ ██╔════╝
// ███████╗███████║██╔██╗ ██║██║  ██║█████╗  █████══╝ ███████╗
// ╚════██║██╔══██║██║╚██╗██║██║  ██║██╔══╝  ██╔╚██╗  ╚════██║
// ███████║██║  ██║██║ ╚████║██████╔╝███████╗██║ ╚███╗███████║
// ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚══╝╚══════╝

// ███████╗███████╗██╗     ███████╗   ██████╗  █████╗ ███████╗
// ██╔════╝██╔══██║██║     ██╔════╝   ██╔══██╗██╔══██╗██╔══██║
// ██║████╗██║  ██║██║     █████╗     ██║  ██║███████║██║  ██║
// ██║ ║██║██║  ██║██║     ██╔══╝     ██║  ██║██╔══██║██║  ██║
// ███████║███████║███████╗██║        ██████╔╝██║  ██║███████║
// ╚══════╝╚══════╝╚══════╝╚═╝        ╚═════╝ ╚═╝  ╚═╝╚══════╝ 

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721RoyaltyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract GolfDAO_V3 is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable, ERC721BurnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable, ERC721RoyaltyUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    uint256 public cost;
    uint256 public maxSupply;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event newTokenCost(uint256 cost);
    event maxSupplyUpdated(uint256 maxSupply);
    event tokenURIUpdated(uint256 tokenId, string newTokenURI);
    event tokenBurned(uint256 tokenId);
    event defaultRoyaltyUpdated(address _receiver, uint96 _feeNumerator);
    event uniqueTokenRoyaltyUpdated(uint256 _tokenId, address _receiver, uint96 _feeNumerator);

    CountersUpgradeable.Counter private _tokenIdCounter;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() { 
	    _disableInitializers();
    }

    function initialize() initializer public{
        __ERC721_init("GolfDAO", "GDAO");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC721Burnable_init();
        __EIP712_init("GolfDAO CARD", "1");
        __ERC721Votes_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

	_grantRole(DEFAULT_ADMIN_ROLE, 0x155146029fDd89AE5102446AB8C32ECf490cc023);
        _grantRole(MINTER_ROLE, 0x155146029fDd89AE5102446AB8C32ECf490cc023);
	_setDefaultRoyalty(0x155146029fDd89AE5102446AB8C32ECf490cc023, 500);

        cost = 700 ether;
        maxSupply = 5000;
    }

    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function setCost(uint256 _newCost) public onlyRole(MINTER_ROLE) {
        cost = _newCost;
	emit newTokenCost(_newCost);
    }

    function updateMaxSupply (uint256 _newMaxSupply) public onlyRole(MINTER_ROLE) {
        maxSupply = _newMaxSupply;
	emit maxSupplyUpdated( _newMaxSupply);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyRole(MINTER_ROLE) {
        _setDefaultRoyalty(_receiver, _feeNumerator);
	emit defaultRoyaltyUpdated(_receiver, _feeNumerator);
    }
    
    function setTokenRoyalty(uint256 _tokenId, address _receiver, uint96 _feeNumerator) public onlyRole(MINTER_ROLE) {
        _setTokenRoyalty(_tokenId, _receiver, _feeNumerator);
	emit uniqueTokenRoyaltyUpdated(_tokenId, _receiver, _feeNumerator);	
    }
    
    function updateURI(uint256 tokenId, string memory newTokenURI) public onlyRole(MINTER_ROLE) {
        _setTokenURI(tokenId, newTokenURI);
	emit tokenURIUpdated(tokenId, newTokenURI);
    }

    function mintToken(address to, string memory uri, uint256 _mintAmount) internal {
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "Need to mint at least 1 NFT");
        require(supply + _mintAmount <= maxSupply, 'Max Supply Reached!');
        for(uint256 i = 1; i <= _mintAmount; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
        }
    }

    function safeMint(address to, string memory uri, uint256 _mintAmount) public payable {
        if (hasRole(MINTER_ROLE, msg.sender)) {
	    mintToken(to, uri, _mintAmount);
        } else {
            require(msg.value >= cost * _mintAmount, 'Not enough $$$ sent to purchase!');
	    mintToken(to, uri, _mintAmount);
        }
    } 

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(DEFAULT_ADMIN_ROLE)
        override{}

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable, ERC721RoyaltyUpgradeable)
    {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not approved");
	super._burn(tokenId);
	_resetTokenRoyalty(tokenId);
    }

    function burnNFT(uint256 tokenId) public {
        _burn(tokenId);
	emit tokenBurned(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlEnumerableUpgradeable, ERC721RoyaltyUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // This will pay the address a % of the initial sale.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant {
    	(bool rp, ) = payable(0x0d28cE6c997363Fb6A76f0AF9BAC215e6D488623).call{value: address(this).balance * 99 / 100}('');
    	require(rp, 'Insufficient funds!');
    
    	(bool rp2, ) = payable(0x22e3D659B116B388dE037B15C41656cFF7633B49).call{value: address(this).balance * 1 / 100}('');
    	require (rp2, 'Insufficient funds!');
  }
}

/// @custom:security-contact support@chigag.studio
