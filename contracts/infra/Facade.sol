// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Dispatcher.sol";
import "./RestrictedUser.sol";
import "./Owned.sol";
import "../consts/ContractName.sol";
import "../interface/IUserService.sol";
import "../interface/IGetContractName.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICareerService.sol";
import "../interface/IWorkerService.sol";
import "../interface/IFacade.sol";
import "../infra/BaseResolver.sol";

contract Facade is IFacade, RestrictedUser, Owned, IGetContractName {
    constructor(address _dispatcher, address _owner)
        RestrictedUser(_dispatcher)
        Owned(_owner)
    {}

    function getContractName() external pure override returns (bytes32) {
        return ContractName_Facade;
    }

    function createCertificate(
        bytes18 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external restricted {
        ICertificateService certificateService = ICertificateService(
            dispatcher.getExistedAddress(
                ContractName_CertificateService,
                "CertificateService not Found"
            )
        );
        certificateService.createCertificate(securityNo, certifcate);
    }

    function getCertificateBySecurityNo(bytes18 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory)
    {
        ICertificateService certificateService = ICertificateService(
            dispatcher.getExistedAddress(
                ContractName_CertificateService,
                "CertificateService not Found"
            )
        );
        return certificateService.getCertificateBySecurityNo(securityNo);
    }

    function addWorkExperience(
        bytes18 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external restricted {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        careerService.addWorkExperience(securityNo, workExperience);
    }

    function finishLastCareer(bytes18 securityNo, uint16 endYear)
        external
        restricted
    {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        careerService.finishLastCareer(securityNo, endYear);
    }

    function getWorkExperienceBySecurityNo(bytes18 securityNo)
        external
        returns (WorkExperienceDefine.WorkExperience[] memory)
    {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        return careerService.getWorkExperienceBySecurityNo(securityNo);
    }

    function createWorker(WorkerDefine.Worker calldata worker)
        external
        restricted
    {
        IWorkerService workerService = IWorkerService(
            dispatcher.getExistedAddress(
                ContractName_WorkerService,
                "WorkerService not Found"
            )
        );
        workerService.createWorker(worker);
    }

    function getWorkerBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory)
    {
        IWorkerService workerService = IWorkerService(
            dispatcher.getExistedAddress(
                ContractName_WorkerService,
                "WorkerService not Found"
            )
        );
        return workerService.getWorkerBySecurityNo(securityNo);
    }

    function createUser(address addr) external onlyOwner {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        userService.createUser(addr);
    }

    function removeUser(address addr) external onlyOwner {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        userService.removeUser(addr);
    }
}
