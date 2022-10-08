// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

import "../models/CertificateDefine.sol";
import "../models/WorkerDefine.sol";
import "../models/WorkExperienceDefine.sol";

interface IFacade {
    function createCertificate(
        bytes18 securityNo,
        CertificateDefine.Certificate calldata certifcate
    ) external;

    function getCertificateBySecurityNo(bytes18 securityNo)
        external
        view
        returns (CertificateDefine.Certificate[] memory);

    function addWorkExperience(
        bytes18 securityNo,
        WorkExperienceDefine.WorkExperience calldata workExperience
    ) external;

    function finishLastCareer(bytes18 securityNo, uint16 endYear) external;

    function getWorkExperienceBySecurityNo(bytes18 securityNo)
        external
        returns (WorkExperienceDefine.WorkExperience[] calldata);

    function createWorker(WorkerDefine.Worker calldata worker) external;

    function getWorkerBySecurityNo(bytes18 securityNo)
        external
        view
        returns (WorkerDefine.Worker memory);

    function createUser(address addr) external;

    function removeUser(address addr) external;
}
