// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../models/CertificateDefine.sol";
import "../infra/BaseResolver.sol";
import "../interface/ICertificateStorage.sol";

contract CertificateStorage is ICertificateStorage, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    mapping(bytes32 => CertificateDefine.Certificate[]) certificateMap;

    function createCertificate(
        bytes32 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external {
        CertificateDefine.Certificate[] storage certificates = certificateMap[
            securityNo
        ];
        certificates.push(certifcate);
    }

    function getCertificateBySecurityNo(bytes32 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory)
    {
        CertificateDefine.Certificate[] memory certs = certificateMap[
            securityNo
        ];
        return certs;
    }

    function checkUserHasCertificate(
        bytes32 securityNo,
        bytes32 certificateCode
    ) external view returns (bool) {
        CertificateDefine.Certificate[] memory certs = certificateMap[
            securityNo
        ];
        for (uint i; i < certs.length; i++) {
            if (certs[i].certCode == certificateCode) {
                return true;
            }
        }
        return false;
    }
}
