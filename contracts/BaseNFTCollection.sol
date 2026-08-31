// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BaseNFTCollection is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256) public mintedCount;

    uint256 public maxPerWallet;
    uint256 public mintPrice;
    bool public mintActive;

    event Minted(address to, uint256 tokenId, string uri);
    event MintConfigUpdated(uint256 maxPerWallet, uint256 mintPrice, bool mintActive);

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxPerWallet,
        uint256 _mintPrice
    ) ERC721(name, symbol) Ownable(msg.sender) {
        maxPerWallet = _maxPerWallet;
        mintPrice = _mintPrice;
        mintActive = false;
    }

    function mint(string memory uri) external payable returns (uint256) {
        require(mintActive, "Mint not active");
        require(mintedCount[msg.sender] < maxPerWallet, "Max per wallet reached");
        require(msg.value >= mintPrice, "Insufficient payment");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        _safeMint(msg.sender, tokenId);
        _tokenURIs[tokenId] = uri;
        mintedCount[msg.sender]++;

        emit Minted(msg.sender, tokenId, uri);
        return tokenId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function setMintConfig(
        uint256 _maxPerWallet,
        uint256 _mintPrice,
        bool _mintActive
    ) external onlyOwner {
        maxPerWallet = _maxPerWallet;
        mintPrice = _mintPrice;
        mintActive = _mintActive;
        emit MintConfigUpdated(_maxPerWallet, _mintPrice, _mintActive);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        (bool sent,) = payable(owner).call{value: balance}("");
        require(sent, "Transfer failed");
    }

    function _safeMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId, "");
    }
}
