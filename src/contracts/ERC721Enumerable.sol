// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';


contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // mapping of tokenId to position in _allTokens array
    mapping (uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
    mapping (address => uint256[]) private _ownedTokens;

    // mapping of token ID to index of the owner tokens list
    mapping (uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) public view override returns (uint256) {
        require(
            _index < totalSupply(),
            "Index greater than total supply"
        );
        return _allTokens[_index];
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view override returns (uint256) {
        require(
            _index < balanceOf(_owner),
            "Owner index is out of balance"
        );
        return _ownedTokens[_owner][_index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokensEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        uint256 _index = _allTokens.length;
        _allTokensIndex[tokenId] = _index;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
}