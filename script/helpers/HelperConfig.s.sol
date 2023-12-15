// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {DeployMocks} from "../DeployMocks.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";

contract HelperVariables {
    uint8 private constant DECIMALS = 9;
    int256 private constant INITIAL_ANSWER = 2000e9;

    function getDecimals() public pure returns (uint8) {
        return DECIMALS;
    }

    function getInitalAnswer() public pure returns (int256) {
        return INITIAL_ANSWER;
    }
}

contract HelperConfig {
    HelperVariables private variables = new HelperVariables();

    struct NetworkConfig {
        address aggregator;
    }

    NetworkConfig public currentNetworkConfig;

    constructor() {
        if (block.chainid == 1) {
            currentNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 11155111) {
            currentNetworkConfig = getSepoliaEthConfig();
        } else if(block.chainid == 31337) {
            currentNetworkConfig = getAnvilEthConfig();
        } else if(block.chainid == 1337) {
            currentNetworkConfig = getGanacheEthConfig();
        }
    }

    function getSepoliaEthConfig() private pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaEthConfig = NetworkConfig({
            aggregator: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaEthConfig;
    }

    function getMainnetEthConfig() private pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthconfig = NetworkConfig({
            aggregator: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return mainnetEthconfig;
    }

    function getAnvilEthConfig() private returns (NetworkConfig memory) {
        if(currentNetworkConfig.aggregator != address(0)) {
            return currentNetworkConfig;
        }

        DeployMocks mocks = new DeployMocks();

        MockV3Aggregator mockAggregator = mocks.deployMockV3Aggregator(variables.getDecimals(), variables.getInitalAnswer());

        NetworkConfig memory anvilEthConfig = NetworkConfig({
            aggregator: address(mockAggregator)
        });

        return anvilEthConfig;
    }

    function getGanacheEthConfig() private returns (NetworkConfig memory) {
        if(currentNetworkConfig.aggregator != address(0)) {
            return currentNetworkConfig;
        }

        DeployMocks mocks = new DeployMocks();

        MockV3Aggregator mockAggregator = mocks.deployMockV3Aggregator(variables.getDecimals(), variables.getInitalAnswer());

        NetworkConfig memory anvilEthConfig = NetworkConfig({
            aggregator: address(mockAggregator)
        });

        return anvilEthConfig;
    }
}
