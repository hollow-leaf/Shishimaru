// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { Coupon } from "./Coupon.sol";
import { ICouponFactory } from "./interfaces/ICouponFactory.sol";

/// @title CouponFactory
/// @dev Contract for creating and managing Coupons
contract CouponFactory is ICouponFactory, Ownable {
    uint256 public protocolFeeRate = 0.2e18; // 20%

    mapping (string => address) nameToAddress;

    constructor() Ownable(msg.sender){ }

    /// @dev Withdraws the entire balance of the specified fund asset to the owner
    /// @param fundAsset_ Address of the fund asset
    function withdraw(address fundAsset_) external onlyOwner {
        uint256 balance = IERC20(fundAsset_).balanceOf(address(this));
        IERC20(fundAsset_).transfer(msg.sender, balance);
        emit ProtocolWithdrawn(msg.sender, fundAsset_, balance);
    }

    /// @dev Sets the protocol fee rate
    /// @param protocolFeeRate_ New protocol fee rate
    function setProtocolFeeRate(uint256 protocolFeeRate_) external onlyOwner {
        require(protocolFeeRate_ <= 1e18, "CouponFactory: must <= 100%");
        require(protocolFeeRate_ >= 0, "CouponFactory: must >= 0%");
        protocolFeeRate = protocolFeeRate_;
        emit ProtocolFeeRateSet(protocolFeeRate_);
    }
    /// @dev Mint ERC1155 token by Factory
    /// @param _name Name of the Coupon
    /// @param _tokenId Token ID
    /// @param _amount Amount of token
    function mintDonateNFT(string memory _name, uint256 _tokenId, uint256 _amount) external {
        Coupon(nameToAddress[_name]).mint(msg.sender, _tokenId, _amount);
        emit ERC1155Minted(msg.sender, _name, _amount, _tokenId);
    }

    function addNewERC1155(string memory _ERC1155name, uint256 _mintPrice, string memory _name, string memory _metadataURI) external override{
        uint256 id = Coupon(nameToAddress[_ERC1155name]).addNewNFT(msg.sender,_mintPrice,  _name, _metadataURI);
        emit ERC1155AddNewNFT(_ERC1155name, _mintPrice, _name, _metadataURI, id);
    }

    /*//////////////////////////////////////////////////////////////////////////
                        EXTERNAL NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Creates a new Coupon with the provided configurations
    /// @param _fundAsset Address of the fund asset
    /// @param name Name of the Coupon
    /// @return Coupon_ Address of the created Coupon
    function createCoupon(address _fundAsset, string memory name) external override returns (address coupon_) {
        require(nameToAddress[name] == address(0), "Coupon already exists");
        Coupon coupon = new Coupon(address(this), _fundAsset, msg.sender);
        nameToAddress[name] = address(coupon);
        emit CouponCreated(msg.sender, address(coupon), name, _fundAsset);
        return (address(coupon));
    }
}