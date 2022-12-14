// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../infra/BaseResolver.sol";
import "../consts/ContractName.sol";
import "../consts/BusinessConsts.sol";
import "../interface/ICareerStorage.sol";
import "../interface/IWorkerStorage.sol";
import "../interface/ICareerService.sol";

contract CareerService is
    ICareerService,
    ContractName,
    BusinessConsts,
    BaseResolver
{
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function addWorkExperience(
        bytes32 securityNo,
        WorkExperienceDefine.WorkExperience memory workExperience
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
        emit careerExperienceCreated(workExperience);
    }

    function finishLastCareer(bytes32 securityNo, uint16 endYear) external {
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

    function getWorkExperienceBySecurityNo(bytes32 securityNo)
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

    event careerExperienceCreated(WorkExperienceDefine.WorkExperience workExperience);
}
