// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/BaseResolver.sol";
import "../interface/IUserStorage.sol";
import "../interface/IGetContractName.sol";
import "../consts/ContractName.sol";

contract UserStorage is
    IUserStorage,
    BaseResolver,
    ContractName,
    IGetContractName
{
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function getContractName() external pure returns (bytes32) {
        return ContractName_UserStorage;
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
