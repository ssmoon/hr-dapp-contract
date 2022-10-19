// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../infra/BaseResolver.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICertificateStorage.sol";
import "../interface/IWorkerStorage.sol";

contract CertificateService is ContractName, ICertificateService, BaseResolver {
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function createCertificate(
        bytes32 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        bool workerExist = workerStorage.checkWorkerExist(securityNo);
        require(
            workerExist,
            "securityNo not exist in worker repo, append it first"
        );

        ICertificateStorage certificateStorage = ICertificateStorage(
            dispatcher.getExistedAddress(
                ContractName_CertificateStorage,
                "CertificateStorage not Found"
            )
        );

        bool certExist = certificateStorage.checkUserHasCertificate(
            securityNo,
            certifcate.certCode
        );
        require(
            !certExist,
            string.concat(
                "certCode: ",
                string(abi.encodePacked(certifcate.certCode)),
                " already exists"
            )
        );

        certificateStorage.createCertificate(securityNo, certifcate);
    }

    function getCertificateBySecurityNo(bytes32 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory)
    {
        ICertificateStorage certificateStorage = ICertificateStorage(
            dispatcher.getExistedAddress(
                ContractName_CertificateStorage,
                "CertificateStorage not Found"
            )
        );
        return certificateStorage.getCertificateBySecurityNo(securityNo);
    }
}
