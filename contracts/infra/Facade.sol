// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./Dispatcher.sol";
import "../interface/IDispatcher.sol";
import "../consts/ContractName.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICareerService.sol";
import "../interface/IWorkerService.sol";
import "../infra/BaseResolver.sol";

contract Facade is ContractName, Initializable, AccessControlUpgradeable {
    bytes32 public constant PRIVILEGED_ROLE = keccak256("PRIVILEGED_ROLE");
    IDispatcher internal dispatcher;

    function initialize(address _dispatcher) public initializer {
        dispatcher = IDispatcher(_dispatcher);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function createCertificate(
        bytes32 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external onlyRole(PRIVILEGED_ROLE) {
        ICertificateService certificateService = ICertificateService(
            dispatcher.getExistedAddress(
                ContractName_CertificateService,
                "CertificateService not Found"
            )
        );
        certificateService.createCertificate(securityNo, certifcate);
    }

    function getCertificateBySecurityNo(bytes32 securityNo)
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
        bytes32 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external onlyRole(PRIVILEGED_ROLE) {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        careerService.addWorkExperience(securityNo, workExperience);
    }

    function finishLastCareer(bytes32 securityNo, uint16 endYear)
        external
        onlyRole(PRIVILEGED_ROLE)
    {
        ICareerService careerService = ICareerService(
            dispatcher.getExistedAddress(
                ContractName_CareerService,
                "CareerService not Found"
            )
        );
        careerService.finishLastCareer(securityNo, endYear);
    }

    function getWorkExperienceBySecurityNo(bytes32 securityNo)
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
        onlyRole(PRIVILEGED_ROLE)
    {
        IWorkerService workerService = IWorkerService(
            dispatcher.getExistedAddress(
                ContractName_WorkerService,
                "WorkerService not Found"
            )
        );
        workerService.createWorker(worker);
    }

    function getWorkerBySecurityNo(bytes32 securityNo)
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

    // the internal function call will validate user purview
    function createUser(address addr) external {
        grantRole(PRIVILEGED_ROLE, addr);
    }

    // the internal function call will validate user purview
    function removeUser(address addr) external {
        revokeRole(PRIVILEGED_ROLE, addr);
    }

    function checkUserExist(address addr) external view returns (bool) {
        return hasRole(PRIVILEGED_ROLE, addr);
    }

    function ping() external pure returns (bytes32) {
        return "pong";
    }

    function pingByOwner()
        external
        view
        onlyRole(getRoleAdmin(DEFAULT_ADMIN_ROLE))
        returns (bytes32)
    {
        return "pong";
    }

    function pingByPrivilegedUser()
        external
        view
        onlyRole(PRIVILEGED_ROLE)
        returns (bytes32)
    {
        return "pong";
    }
}
