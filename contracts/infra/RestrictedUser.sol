// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/Dispatcher.sol";
import "../consts/ContractName.sol";
import "../interface/IUserStorage.sol";
import "../infra/BaseResolver.sol";
import "../interface/IGetContractName.sol";
import "../infra/Owned.sol";

contract RestrictedUser is ContractName, BaseResolver, Owned {
    constructor(address _dispatcher, address _owner)
        BaseResolver(_dispatcher)
        Owned(_owner)
    {}

    modifier restricted() {
        IUserStorage userStorage = IUserStorage(
            dispatcher.getExistedAddress(
                ContractName_UserStorage,
                "UserStorage not Found"
            )
        );
        require(
            userStorage.checkUserExist(msg.sender) || isOwner(msg.sender),
            "Only the restricted user may perform this action"
        );
        _;
    }
}
