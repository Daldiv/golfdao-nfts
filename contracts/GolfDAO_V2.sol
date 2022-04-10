// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/draft-ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

/// @custom:security-contact support@chigag.studio
contract GolfDAO_V2 is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, OwnableUpgradeable, ERC721BurnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    uint256 public cost;
    uint256 public maxSupply;

    CountersUpgradeable.Counter private _tokenIdCounter;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public{
        __ERC721_init("GolfDAO", "GDAO");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __EIP712_init("GolfDAO", "1");
        __ERC721Votes_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();
        cost = 700 ether;
        maxSupply = 5000;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function updateURI(uint256 tokenId, string memory newTokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not owner nor approved");
        _setTokenURI(tokenId, newTokenURI);
    }

    function safeMint(address to, string memory uri) public payable{
        if (msg.sender != owner()) {
            require(msg.value >= cost, 'Insufficient funds!');
        }
        uint256 tokenId = _tokenIdCounter.current();
        if (tokenId <= maxSupply) {
            revert('Max supply reached');
        }
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
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
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // This will pay the address a % of the initial sale.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    function withdraw() public onlyOwner nonReentrant {
    (bool rp, ) = payable(0x0d28cE6c997363Fb6A76f0AF9BAC215e6D488623).call{value: address(this).balance * 99 / 100}('');
    require(rp, 'Insufficient funds!');
    
    (bool rp2, ) = payable(0x22e3D659B116B388dE037B15C41656cFF7633B49).call{value: address(this).balance * 1 / 100}('');
    require (rp2, 'Insufficient funds!');

    // This will transfer the remaining contract balance to the owner.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}('');
    require(os);
  }
}

