// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Owned.sol";
import "../interface/IDispatcher.sol";
import "../consts/ContractName.sol";

contract Dispatcher is Owned, IDispatcher {
    mapping(bytes32 => address) public repository;

    constructor(address _owner) Owned(_owner) {}

    function importAddress(bytes32 name, address destination)
        external
        onlyOwner
    {
        repository[name] = destination;
    }

    function areAddressesImported(
        bytes32[] calldata names,
        address[] calldata destinations
    ) external view returns (bool) {
        for (uint i = 0; i < names.length; i++) {
            if (repository[names[i]] != destinations[i]) {
                return false;
            }
        }
        return true;
    }

    function tryGetAddress(bytes32 name) external view returns (address) {
        return repository[name];
    }

    function getExistedAddress(bytes32 name, string calldata reason)
        external
        view
        returns (address)
    {
        address _foundAddress = repository[name];
        require(_foundAddress != address(0), reason);
        return _foundAddress;
    }

    /* ========== EVENTS ========== */

    event AddressImported(bytes32 name, address destination);
}
