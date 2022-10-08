// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../infra/Dispatcher.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICertificateStorage.sol";
import "../interface/IWorkerStorage.sol";

contract CertificateService is ContractName, ICertificateService {
    Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }

    function createCertificate(
        bytes18 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external {
        IWorkerStorage workerStorage = IWorkerStorage(
            dispatcher.getExistedAddress(
                ContractName_WorkerStorage,
                "WorkerStorage not Found"
            )
        );
        bool exist = workerStorage.checkWorkerExist(securityNo);
        require(exist, "securityNo not exist in worker repo, append it first");

        ICertificateStorage certificateStorage = ICertificateStorage(
            dispatcher.getExistedAddress(
                ContractName_CertificateStorage,
                "CertificateStorage not Found"
            )
        );
        certificateStorage.createCertificate(securityNo, certifcate);
    }

    function getCertificateBySecurityNo(bytes18 securityNo)
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
