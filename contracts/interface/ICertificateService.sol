// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/CertificateDefine.sol";

interface ICertificateService {
    function createCertificate(
        bytes32 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external;

    function getCertificateBySecurityNo(bytes32 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory);
}
