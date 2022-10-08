// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/IUserStorage.sol";
import "../interface/IUserService.sol";
import "../infra/Dispatcher.sol";

contract UserService is ContractName, IUserService {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    function createUser(address addr) external {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        bool exist = userStorage.checkUserExist(addr);
        require(!exist, "User addr already exists");
        userStorage.createUser(addr);
    }

    function removeUser(address addr) external {
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
}
