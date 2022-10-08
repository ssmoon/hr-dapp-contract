// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Dispatcher.sol";

contract Facade {
    Dispatcher private dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    function CalcSum() external pure returns (string memory) {
        return "hello";
    }

    function addCareer
}
