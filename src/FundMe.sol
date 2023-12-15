// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {PriceConverter} from "./library/PriceConverter.sol";

error FundMe__notEnoughETH();
error FundMe__notOwner();

contract FundMe {
    address public immutable aggregatorAddress;

    uint256 private constant MINIMUM_USD = 50;

    uint256 addressToDonatedNonce = 0;
    mapping(uint256 => mapping(address => uint256)) private addressToDonatedAmount;

    address public immutable owner;

    constructor(address add) {
        require(add != address(0));

        aggregatorAddress = add;
        owner = msg.sender;
    }

    modifier minimumDonation() {
        if (PriceConverter.ethToUsd(aggregatorAddress, msg.value) < MINIMUM_USD) {
            revert FundMe__notEnoughETH();
        }
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert FundMe__notOwner();
        }
        _;
    }

    function donate() external payable minimumDonation {
        addressToDonatedAmount[addressToDonatedNonce][msg.sender] += msg.value;
    }

    function ownerWithdraw() external onlyOwner {
        (bool sent,) = payable(owner).call{value: address(this).balance}("");
        require(sent);
        addressToDonatedNonce++;
    }

    function getMinimumUsd() external pure returns(uint256) {
        return MINIMUM_USD;
    }

    function getAddressToDonatedAmount(address add) external view returns(uint256) {
        return addressToDonatedAmount[addressToDonatedNonce][add];
    }
}
