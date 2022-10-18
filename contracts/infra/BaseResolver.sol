// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Dispatcher.sol";
import "../interface/IDispatcher.sol";

contract BaseResolver {
    IDispatcher internal dispatcher;

    constructor(address _dispatcher) {
        dispatcher = IDispatcher(_dispatcher);
    }
}
