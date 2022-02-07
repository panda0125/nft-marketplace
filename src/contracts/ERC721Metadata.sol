// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import './ERC165.sol';
import './interfaces/IERC721Metadata.sol';


contract ERC721Metadata is IERC721Metadata, ERC165 {

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;

        registerInterface(bytes4(keccak256('name(bytes4)')^keccak256('symbol(bytes4)')));
    }

    function name() view external override returns (string memory) {
        return _name;
    }

    function symbol() view external override returns (string memory) {
        return _symbol;
    }
}
