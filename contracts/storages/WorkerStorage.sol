// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/WorkerDefine.sol";
import "../infra/BaseResolver.sol";
import "../interface/IWorkerStorage.sol";

contract WorkerStorage is IWorkerStorage, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    mapping(bytes32 => WorkerDefine.Worker) workerMap;

    function createWorker(WorkerDefine.Worker calldata worker) external {
        workerMap[worker.securityNo] = worker;
        // existedWorker.securityNo = worker.securityNo;
        // existedWorker.graduatedAt = worker.graduatedAt;
        // existedWorker.collegeCode = worker.collegeCode;
        // existedWorker.birthAt = worker.birthAt;
        // existedWorker.isValue = true;
    }

    function getWorkerBySecurityNo(bytes32 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory)
    {
        return workerMap[securityNo];
    }

    function checkWorkerExist(bytes32 securityNo) external view returns (bool) {
        return workerMap[securityNo].isValue;
    }
}
