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

  await deployer.deploy(ProxyContract)
  const ProxyDeployed = await ProxyContract.deployed();

  // contract discovery center
  await deployer.deploy(DispatcherContract, ProxyDeployed.address);
  const DispatcherDeployed = await DispatcherContract.deployed();

  // proxy delegate impl
  await deployer.deploy(FacadeContract, DispatcherDeployed.address, account);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("Facade"), FacadeContract.address)

  // set current proxyed impl
  await ProxyDeployed.setImplementation(FacadeContract.address);

  // deploy and register all other contracts

  await deployer.deploy(CareerServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("CareerService", CareerServiceContract.address);

  await deployer.deploy(CareerStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("CareerStorage", CareerStorageContract.address);

  await deployer.deploy(UserServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("UserService", UserServiceContract.address);

  await deployer.deploy(UserStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("UserStorage", UserStorageContract.address);

  await deployer.deploy(WorkerServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("WorkerService", WorkerServiceContract.address);

  await deployer.deploy(WorkerStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("WorkerStorage", WorkerStorageContract.address);

  await deployer.deploy(CertificateServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("CertificateService", CertificateServiceContract.address);

  await deployer.deploy(CertificateStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress("CertificateStorage", CertificateStorageContract.address);
}

module.exports = migration

export { }