//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getETHPrice(address aggregatorAddress) internal view returns (uint256) {
        AggregatorV3Interface aggregator = AggregatorV3Interface(aggregatorAddress);
        (, int256 price,,,) = aggregator.latestRoundData();

        return uint256(price);
    }

    function ethToUsd(address aggregatorAddress, uint256 ethAmount) internal view returns (uint256) {
        AggregatorV3Interface aggregator = AggregatorV3Interface(aggregatorAddress);
        uint256 price = getETHPrice(aggregatorAddress);

        return price * ethAmount / ((10 ** aggregator.decimals()) * 1e18);
    }
}