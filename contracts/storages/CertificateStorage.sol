// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/CertificateDefine.sol";
import "../infra/BaseResolver.sol";
import "../interface/ICertificateStorage.sol";

contract CertificateStorage is ICertificateStorage, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    mapping(bytes18 => CertificateDefine.Certificate[]) certificateMap;

    function createCertificate(
        bytes18 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external {
        CertificateDefine.Certificate[] storage certificates = certificateMap[
            securityNo
        ];
        certificates.push(certifcate);
    }

    function getCertificateBySecurityNo(bytes18 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory)
    {
        CertificateDefine.Certificate[] memory certs = certificateMap[
            securityNo
        ];
        return certs;
    }
}
