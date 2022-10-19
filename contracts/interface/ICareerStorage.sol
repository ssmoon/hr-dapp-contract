// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/WorkExperienceDefine.sol";

interface ICareerStorage {
    function createCareer(
        bytes32 securityNo,
        WorkExperienceDefine.WorkExperience calldata newExperience
    ) external;

    function finishLastCareer(bytes32 securityNo, uint16 endYear) external;

    function getLastCareer(bytes32 securityNo)
        external
        view
        returns (WorkExperienceDefine.WorkExperience memory);

    function getCareerBySecurityNo(bytes32 securityNo)
        external
        view
        returns (WorkExperienceDefine.WorkExperience[] memory);
}
