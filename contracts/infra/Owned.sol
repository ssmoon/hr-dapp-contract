// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

// https://docs.synthetix.io/contracts/source/contracts/owned
contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor(address _owner) {
        setOwner(_owner);
    }

    function setOwner(address _owner) internal {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function isOwner(address _owner) internal view returns (bool) {
        return _owner == owner;
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(
            msg.sender == nominatedOwner,
            "You must be nominated before you can accept ownership"
        );
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner() {
        emit checkResitricted(msg.sender, owner);
        require(
            msg.sender == owner,
            "Only the contract owner may perform this action"
        );
        _;
    }

    event checkResitricted(address addrSender, address addrOwner);
    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}
