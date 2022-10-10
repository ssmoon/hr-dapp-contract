// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/IWorkerStorage.sol";
import "../interface/IWorkerService.sol";
import "../infra/BaseResolver.sol";

contract WorkerService is ContractName, IWorkerService, BusinessConsts, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function createWorker(WorkerDefine.Worker calldata worker) external {
        require(
            worker.graduatedAt > MIN_WORK_START_YEAR,
            "graduatedAt of worker not valid"
        );

        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );

        bool exist = workerStorage.checkWorkerExist(worker.securityNo);
        require(!exist, "this securityNo already exists");
        workerStorage.createWorker(worker);
    }

    function getWorkerBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory)
    {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        return workerStorage.getWorkerBySecurityNo(securityNo);
    }
}
