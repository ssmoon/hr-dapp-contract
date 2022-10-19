// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

library WorkExperienceDefine {
    struct WorkExperience {
        uint16 startAt;
        uint16 endAt;
        bool hasEnded;
        bytes32 companyCode;
    }
}