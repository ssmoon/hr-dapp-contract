// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IDispatcher {
    function importAddress(bytes32 name, address destination) external;

    function areAddressesImported(
        bytes32[] calldata names,
        address[] calldata destinations
    ) external view returns (bool);

    function tryGetAddress(bytes32 name) external view returns (address);

    function getExistedAddress(bytes32 name, string calldata reason)
        external
        view
        returns (address);

    function getString() external pure returns (string memory);
}
