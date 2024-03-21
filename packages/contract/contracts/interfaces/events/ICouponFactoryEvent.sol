// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ICouponFactoryEvent {
    event CouponExtended(address indexed issuer_, uint256 indexed expiredTime_);

    event CouponCreated(address indexed issuer_, address indexed Coupon_, string indexed name_, uint256 latitude_, uint256 longitude_);

    event ProtocolFeeRateSet(uint256 protocolFeeRate_);

    event ProtocolWithdrawn(address indexed to_, uint256 indexed amount_);

    event ERC1155Minted(address indexed to_, string indexed ERC1155name_, uint256 indexed amount_, uint256 tokenId_);

    event ERC1155BatchMinted(address indexed to_, string indexed ERC1155name_, uint256[] indexed amounts_, uint256[] tokenId_);

    event ERC1155AddNewNFT(string indexed ERC1155name_, uint256 indexed mintPrice_, string indexed name_, string metadataURI_, uint256 tokenId_);
}