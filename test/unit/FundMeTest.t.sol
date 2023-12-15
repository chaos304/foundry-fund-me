// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../../src/FundMe.sol";
import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {AggregatorV3Interface} from "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    uint256 constant MINIMUM_DONATION = 50;

    uint256 constant DONATION_VALUE = 0.1 ether;

    uint160 constant NUMBER_OF_FUNDERS = 5;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.deployFundMe();
    }

    function testMinimumDonationIsFifty() public {
        assertEq(fundMe.getMinimumUsd(), MINIMUM_DONATION);
    }

    function testMsgSenderIsOwner() public fund(1){
        address owner = fundMe.owner();
        assertEq(owner, msg.sender);
    }

    function testDonateRevertsBelowMinimum() public {
        vm.expectRevert(FundMe__notEnoughETH.selector);
        fundMe.donate();
    }

    modifier fund(uint160 numberOfFunders) {
        for(uint160 i = 1; i <= numberOfFunders; i++) {
            hoax(address(i));
            fundMe.donate{value: DONATION_VALUE}();
        }
        _;
    }

    function testCanDonate() public fund(NUMBER_OF_FUNDERS) {
        uint256 currentContractBalance = address(fundMe).balance;
        uint256 expectedContractBalance = NUMBER_OF_FUNDERS * DONATION_VALUE;

        assertEq(currentContractBalance, expectedContractBalance);
    }

    function testDonatorMappingUpdatedCorrectly() public fund(NUMBER_OF_FUNDERS) {
        uint256 expectedTotalValue = NUMBER_OF_FUNDERS * DONATION_VALUE;

        uint256 actualTotalValue = 0;
        for(uint160 i = 1; i <= NUMBER_OF_FUNDERS; i++) {
            actualTotalValue += fundMe.getAddressToDonatedAmount(address(i));
        }

        assertEq(actualTotalValue, expectedTotalValue);
    }

    function testUserCantWithdraw() public fund(NUMBER_OF_FUNDERS) {
        vm.expectRevert(FundMe__notOwner.selector);
        vm.prank(address(1));
        fundMe.ownerWithdraw();
        
    }

    function testOwnerCanWithdraw() public fund(NUMBER_OF_FUNDERS) {
        vm.startPrank(fundMe.owner());

        uint256 ownerBalanceBefore = msg.sender.balance;
        uint256 contractBalance = address(fundMe).balance;

        fundMe.ownerWithdraw();

        uint256 ownerBalanceAfter = msg.sender.balance;
        uint256 expectedOwnerBalance = ownerBalanceBefore + contractBalance;

        vm.stopPrank();
        assertEq(ownerBalanceAfter, expectedOwnerBalance);
    }
}
