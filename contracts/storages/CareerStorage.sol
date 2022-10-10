// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/WorkExperienceDefine.sol";
import "../infra/Dispatcher.sol";
import "../infra/BaseResolver.sol";
import "../interface/ICareerStorage.sol";

contract CareerStorage is ICareerStorage, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    mapping(bytes18 => WorkExperienceDefine.WorkExperience[]) workerExperienceMap;

    function createCareer(
        bytes18 securityNo,
        WorkExperienceDefine.WorkExperience calldata newExperience
    ) external {
        workerExperienceMap[securityNo].push(newExperience);
    }

    function finishLastCareer(bytes18 securityNo, uint16 endYear) external {
        WorkExperienceDefine.WorkExperience[]
            storage existedExperiences = workerExperienceMap[securityNo];
        require(existedExperiences.length > 0, "last experience not found");
        WorkExperienceDefine.WorkExperience
            storage lastExperience = existedExperiences[
                existedExperiences.length - 1
            ];
        require(!lastExperience.hasEnded, "last experience has already ended");
        lastExperience.hasEnded = true;
        lastExperience.endAt = endYear;
    }

    function getLastCareer(bytes18 securityNo)
        external
        view
        returns (WorkExperienceDefine.WorkExperience memory)
    {
        WorkExperienceDefine.WorkExperience[]
            memory existedExperiences = workerExperienceMap[securityNo];
        if (existedExperiences.length == 0) {
            return
                WorkExperienceDefine.WorkExperience({
                    startAt: 0,
                    endAt: 0,
                    hasEnded: false,
                    companyCode: ""
                });
        } else {
            return existedExperiences[existedExperiences.length - 1];
        }
    }

    function getCareerBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkExperienceDefine.WorkExperience[] memory)
    {
        WorkExperienceDefine.WorkExperience[] memory exps = workerExperienceMap[
            securityNo
        ];
        return exps;
    }
}
