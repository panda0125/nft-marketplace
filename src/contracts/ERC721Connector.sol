// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import './ERC721Metadata.sol';
import './ERC721Enumerable.sol';


contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {}

}
