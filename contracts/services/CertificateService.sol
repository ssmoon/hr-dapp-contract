// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../consts/ContractName.sol";
import "../infra/Dispatcher.sol";
import "../interface/ICertificateService.sol";
import "../interface/ICertificateStorage.sol";

contract CertificateService is ContractName, ICertificateService {
      Dispatcher public dispatcher;

    constructor(Dispatcher _dispatcher) {
        dispatcher = _dispatcher;
    }


}