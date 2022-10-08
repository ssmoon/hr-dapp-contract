// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/IWorkerStorage.sol";
import "../interface/IWorkerService.sol";
import "../infra/Dispatcher.sol";

contract CertificateService is ContractName, IWorkerStorage, BusinessConsts {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

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

        WorkerDefine.Worker memory existedWorker = workerStorage
            .getWorkerBySecurityNo(worker.securityNo);
        require(!existedWorker.isValue, "this securityNo has already existed");
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
