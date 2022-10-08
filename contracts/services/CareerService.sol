// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../interface/ICareerService.sol";
import "../infra/Dispatcher.sol";
import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/ICareerStorage.sol";
import "../interface/IWorkerStorage.sol";

contract CareerService is ICareerService, ContractName, BusinessConsts {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    function addWorkExperience(
        bytes18 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        bool exist = workerStorage.checkWorkerExist(securityNo);
        require(exist, "securityNo not exist in worker repo, append it first");

        uint16 currentYear = (uint16)((block.timestamp / 31557600) + 1970);
        require(
            workExperience.startAt >= MIN_WORK_START_YEAR &&
                workExperience.startAt <= currentYear,
            "StartYear value must be between 2000 and current year"
        );
        require(
            workExperience.endAt >= workExperience.startAt &&
                workExperience.endAt <= currentYear,
            "EndYear value must be between StartYear and current year"
        );
        ICareerStorage careerIntr = ICareerStorage(
            dispatcher.getExistedAddress(
                ContractName_CareerStorage,
                "CareerStorage not Found"
            )
        );
        WorkExperienceDefine.WorkExperience memory lastExperience = careerIntr
            .getLastCareer(securityNo);
        if (
            lastExperience.startAt >= MIN_WORK_START_YEAR &&
            !lastExperience.hasEnded
        ) {
            careerIntr.finishLastCareer(securityNo, currentYear);
        }
        careerIntr.createCareer(securityNo, workExperience);
    }

    function finishLastCareer(bytes18 securityNo, uint16 endYear) external {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        bool exist = workerStorage.checkWorkerExist(securityNo);
        require(exist, "securityNo not exist in worker repo, append it first");

        ICareerStorage careerIntr = ICareerStorage(
            dispatcher.getExistedAddress(
                ContractName_CareerStorage,
                "CareerStorage not Found"
            )
        );
        WorkExperienceDefine.WorkExperience memory lastExperience = careerIntr
            .getLastCareer(securityNo);
        require(
            lastExperience.startAt >= MIN_WORK_START_YEAR,
            "last career experience not found"
        );
        require(
            !lastExperience.hasEnded,
            "last career experience has already ended"
        );
        careerIntr.finishLastCareer(securityNo, endYear);
    }

    function getWorkExperienceBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkExperienceDefine.WorkExperience[] memory)
    {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        bool exist = workerStorage.checkWorkerExist(securityNo);
        require(exist, "securityNo not exist in worker repo, append it first");
        
        ICareerStorage careerIntr = ICareerStorage(
            dispatcher.getExistedAddress(
                ContractName_CareerStorage,
                "CareerStorage not Found"
            )
        );
        return careerIntr.getCareerBySecurityNo(securityNo);
    }
}
