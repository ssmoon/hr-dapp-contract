// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../infra/BaseResolver.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICertificateStorage.sol";
import "../interface/IWorkerStorage.sol";
import "../interface/IGetContractName.sol";

contract CertificateService is
    ContractName,
    ICertificateService,
    BaseResolver,
    IGetContractName
{
    constructor(address _dispatcher) BaseResolver(_dispatcher) {}

    function getContractName() external pure returns (bytes32) {
        return ContractName_CertificateService;
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
