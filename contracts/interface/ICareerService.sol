// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/WorkExperienceDefine.sol";

interface ICareerService {
    function addWorkExperience(
        bytes18 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external;

    function finishLastCareer(bytes18 securityNo, uint16 endYear) external;

    function getWorkExperienceBySecurityNo(bytes18 securityNo)
        external
        returns (WorkExperienceDefine.WorkExperience[] calldata);
}
