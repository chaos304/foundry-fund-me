// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./helpers/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external {
        deployFundMe();
    }

    function deployFundMe() public returns(FundMe) {
        HelperConfig config = new HelperConfig();
        address aggregator = config.currentNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(aggregator);
        vm.stopBroadcast();

        return fundMe;
    }
}
