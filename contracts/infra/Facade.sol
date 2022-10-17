// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./Dispatcher.sol";
import "../interface/IDispatcher.sol";
import "../consts/ContractName.sol";
import "../interface/IUserService.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICareerService.sol";
import "../interface/IWorkerService.sol";
import "../infra/BaseResolver.sol";

contract Facade is ContractName, Initializable {
    IDispatcher internal dispatcher;

    function initialize(address _dispatcher) public initializer {
        dispatcher = IDispatcher(_dispatcher);
    }

    function createCertificate(
        bytes18 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external {
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
    ) external {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        careerService.addWorkExperience(securityNo, workExperience);
    }

    function finishLastCareer(bytes18 securityNo, uint16 endYear) external {
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

    function createWorker(WorkerDefine.Worker calldata worker) external {
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

    function createUser(address addr) external {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        userService.createUser(addr);
    }

    function removeUser(address addr) external {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        userService.removeUser(addr);
    }

    function checkUserExist(address addr) external view returns (bool) {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        return userService.checkUserExist(addr);
    }

    function getOwner() external view returns (bytes32) {
        IUserService userService = IUserService(
            dispatcher.getExistedAddress(
                ContractName_UserService,
                "UserService not Found"
            )
        );
        return userService.getOwner();
    }

    function ping() external pure returns (bytes32) {
        return ContractName_UserService;
    }

    function pong() external view returns (address) {
        // return dispatcher.getString();
        return dispatcher.getExistedAddress(ContractName_UserService, "not exist");
    }
}
