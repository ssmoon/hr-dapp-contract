// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IUserService {
    function createUser(address addr) external;

    function removeUser(address addr) external;
}
