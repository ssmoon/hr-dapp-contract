// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract Proxy {
    address private implementation;

    function setImplementation(address storageImplementation) external {
        implementation = storageImplementation;
    }

    fallback() external {
        delegate(implementation);
    }

    function delegate(address a) internal {
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(gas(), a, 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
