// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/Dispatcher.sol";
import "../interface/IUserStorage.sol";

contract UserStorage is IUserStorage {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    mapping(address => bool) userMapping;

    function createUser(address addr) external {
        userMapping[addr] = true;
    }

    function removeUser(address addr) external {
        delete userMapping[addr];
    }

    function checkUserExist(address addr) external view returns (bool) {
        return userMapping[addr];
    }
}
