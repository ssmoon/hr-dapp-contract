// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/WorkExperienceDefine.sol";

interface ICareerService {
    function addWorkExperience(
        bytes32 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external;

    function finishLastCareer(bytes32 securityNo, uint16 endYear) external;

    function getWorkExperienceBySecurityNo(bytes32 securityNo)
        external
        returns (WorkExperienceDefine.WorkExperience[] calldata);
}
