// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract Proxy is ERC721Upgradeable {
    function initialize() public initializer {
        __ERC721_init("MyCollectible", "MCO");
    }

    address private implementation;

    function setImplementation(address _implementation) external {
        implementation = _implementation;
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
