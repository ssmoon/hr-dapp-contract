// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/WorkerDefine.sol";

interface IWorkerStorage {
    function createWorker(WorkerDefine.Worker calldata worker) external;

    function getWorkerBySecurityNo(bytes32 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory);

    function checkWorkerExist(bytes32 securityNo) external view returns (bool);
}
