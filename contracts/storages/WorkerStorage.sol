// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/WorkerDefine.sol";
import "../infra/BaseResolver.sol";
import "../interface/IWorkerStorage.sol";
import "../interface/IGetContractName.sol";
import "../consts/ContractName.sol";

contract WorkerStorage is
    IWorkerStorage,
    ContractName,
    BaseResolver,
    IGetContractName
{
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function getContractName() external pure returns (bytes32) {
        return ContractName_WorkerStorage;
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
