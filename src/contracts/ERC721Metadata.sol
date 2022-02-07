// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


contract ERC721Metadata {

    string public _name;
    string public _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() view external returns (string memory) {
        return _name;
    }

    function symbol() view external returns (string memory) {
        return _symbol;
    }
}
