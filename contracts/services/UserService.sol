// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/IUserStorage.sol";
import "../interface/IUserService.sol";
import "../infra/RestrictedUser.sol";

contract UserService is ContractName, IUserService, RestrictedUser {
    constructor(address _dispatcher, address _owner)
        RestrictedUser(_dispatcher, _owner)
    {}

    function getOwner() external view returns (bytes32) {
        return "abcde";
    }

    function createUser(address addr) external {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        // bool exist = userStorage.checkUserExist(addr);
        // require(!exist, "User addr already exists");
        userStorage.createUser(addr);
    }

    function removeUser(address addr) external onlyOwner {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        bool exist = userStorage.checkUserExist(addr);
        require(exist, "User addr not found");
        userStorage.removeUser(addr);
    }

    function checkUserExist(address addr) external view returns (bool) {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        return userStorage.checkUserExist(addr);
    }
}
