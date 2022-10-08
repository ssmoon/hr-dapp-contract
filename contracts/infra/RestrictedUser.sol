// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/Dispatcher.sol";
import "../consts/ContractName.sol";
import "../interface/IUserStorage.sol";

contract RestrictedUser is ContractName {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    modifier restricted() {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        require(
            userStorage.checkUserExist(msg.sender),
            "Only the restricted user may perform this action"
        );
        _;
    }
}
