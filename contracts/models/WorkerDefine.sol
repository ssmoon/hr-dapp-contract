// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

library WorkerDefine {
    struct Worker {
        // unique value for Chinese citizens, 18 digits
        bytes32 securityNo;
        uint16 graduatedAt;
        uint16 birthAt;
        // collegeCode(first Pinyin alpha character according to the college CN name)
        bytes32 collegeCode;
        // the variable indicates whether this securityNo exists in map
        bool isValue;
    }
}