// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/Dispatcher.sol";
import "../consts/ContractName.sol";
import "../interface/IUserStorage.sol";
import "../infra/BaseResolver.sol";
import "../interface/IGetContractName.sol";

contract RestrictedUser is ContractName, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

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
