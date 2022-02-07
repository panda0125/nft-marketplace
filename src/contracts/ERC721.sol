// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/**
Building out the minting function:
a. NFT to point to an Address
b. Keep track of token IDs
c. Keep track of token owner addresses to token ID
d. Keep track of how many tokens an address has
e. Create an event that emits a Transfer log: contract address, where it's minted to and IDs
 */
contract ERC721 {

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    // Mapping of token ID to owner address
    mapping(uint256 => address) private _tokenOwner;

    // mapping of owner address to token count
    mapping(address => uint256) private _balances;

    // mapping from token ID to approved addresses
    mapping (uint256 => address) private _tokenApprovals;

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) view public returns (uint256) {
        require(
            _owner != address(0),
            'Address must be a valid address'
        );
        return _balances[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Token ID not valid!');
        return owner;
    }

    function _exists(uint256 tokenId) view internal returns (bool) {
        address owner = _tokenOwner[tokenId];
        // return truthiness or owner address
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(
            to != address(0),
            "ERC721: mint address must be a valid address!"
        );

        require(
            !_exists(tokenId),
            "ERC721: token has already been minted!"
        );

        _tokenOwner[tokenId] = to;
        _balances[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, "Token isn't owned by address");

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _tokenApprovals[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_approved != owner, 'Error - Token can not be sent to current owner');
        require(msg.sender == owner, 'Approval made from invalid address');
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) view internal returns (bool) {
        require(_exists(tokenId), 'Token does not exist');
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}