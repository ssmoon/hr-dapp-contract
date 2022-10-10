const ProxyContract = artifacts.require('Proxy')
const DispatcherContract = artifacts.require('Dispatcher')
const FacadeContract = artifacts.require('Facade')

const UserServiceContract = artifacts.require('UserService')
const UserStorageContract = artifacts.require('UserStorage')

const CareerServiceContract = artifacts.require('CareerService')
const CareerStorageContract = artifacts.require('CareerStorage')

const WorkerServiceContract = artifacts.require('WorkerService')
const WorkerStorageContract = artifacts.require('WorkerStorage')

const CertificateServiceContract = artifacts.require('CertificateService')
const CertificateStorageContract = artifacts.require('CertificateStorage')

const migration: Truffle.Migration = async function (deployer, _, accounts) {
  const account = accounts[0];

  deployer.deploy(ProxyContract)
  const ProxyDeployed = await ProxyContract.deployed();

  // contract discovery center
  deployer.deploy(DispatcherContract, ProxyDeployed.address);
  const DispatcherDeployed = await DispatcherContract.deployed();

  // proxy delegate impl
  deployer.deploy(FacadeContract, DispatcherDeployed.address, account);
  DispatcherDeployed.importAddress("Facade", FacadeContract.address)

  // set current proxyed impl
  ProxyDeployed.setImplementation(FacadeContract.address);

  // deploy and register all other contracts

  deployer.deploy(CareerServiceContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("CareerService", CareerServiceContract.address);

  deployer.deploy(CareerStorageContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("CareerStorage", CareerStorageContract.address);

  deployer.deploy(UserServiceContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("UserService", UserServiceContract.address);

  deployer.deploy(UserStorageContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("UserStorage", UserStorageContract.address);
  
  deployer.deploy(WorkerServiceContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("WorkerService", WorkerServiceContract.address);

  deployer.deploy(WorkerStorageContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("WorkerStorage", WorkerStorageContract.address);

  deployer.deploy(CertificateServiceContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("CertificateService", CertificateServiceContract.address);

  deployer.deploy(CertificateStorageContract, DispatcherDeployed.address);
  DispatcherDeployed.importAddress("CertificateStorage", CertificateStorageContract.address);
}

module.exports = migration

export { }