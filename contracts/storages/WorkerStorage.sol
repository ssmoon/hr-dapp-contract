// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/WorkerDefine.sol";
import "../infra/Dispatcher.sol";
import "../interface/IWorkerStorage.sol";

contract WorkerStorage is IWorkerStorage {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    mapping(bytes18 => WorkerDefine.Worker) workerMap;

    function createWorker(WorkerDefine.Worker calldata worker) external {
        workerMap[worker.securityNo] = worker;
        // existedWorker.securityNo = worker.securityNo;
        // existedWorker.graduatedAt = worker.graduatedAt;
        // existedWorker.collegeCode = worker.collegeCode;
        // existedWorker.birthAt = worker.birthAt;
        // existedWorker.isValue = true;
    }

    function getWorkerBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory)
    {
        return workerMap[securityNo];
    }

    function checkWorkerExist(bytes18 securityNo) external view returns (bool) {
        return workerMap[securityNo].isValue;
    }
}
