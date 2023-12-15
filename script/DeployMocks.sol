// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {MockV3Aggregator} from "./mocks/MockV3Aggregator.sol";
import {HelperVariables} from "./helpers/HelperConfig.s.sol";

contract DeployMocks {

    function run() external {
        HelperVariables variables = new HelperVariables();

        deployMockV3Aggregator(variables.getDecimals(), variables.getInitalAnswer());
    }

    function deployMockV3Aggregator(uint8 decimals, int256 initialAnswer) public returns (MockV3Aggregator) {
        MockV3Aggregator mockAggregator = new MockV3Aggregator(decimals, initialAnswer);

        return mockAggregator;
    }
    
}