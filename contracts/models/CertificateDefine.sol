// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

library CertificateDefine {
    struct Certificate {
        // certCode(first Pinyin alpha character of the Certificate)
        // ref to off-chain data to view certificate details
        bytes16 certCode;
        uint16 acquiredAt;
    }
}