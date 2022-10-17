const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades');

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

  console.log("deploying start with owner account: " + account);

  await deployer.deploy(ProxyContract)
  const ProxyDeployed = await ProxyContract.deployed();

  // contract discovery center
  await deployer.deploy(DispatcherContract, account);
  const DispatcherDeployed = await DispatcherContract.deployed();

  // proxy delegate impl
  await deployer.deploy(FacadeContract);
  const facadeDeployed = await FacadeContract.deployed();
  facadeDeployed.setDispatcher(DispatcherDeployed.address);
  // set current proxyed impl
  await ProxyDeployed.setImplementation(FacadeContract.address);

  // deploy and register all other contracts

  await deployer.deploy(UserServiceContract, DispatcherDeployed.address, account);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("UserService"), UserServiceContract.address, { from: account });

  await deployer.deploy(UserStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("UserStorage"), UserStorageContract.address, { from: account });

  await deployer.deploy(CareerServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("CareerService"), CareerServiceContract.address, { from: account });

  await deployer.deploy(CareerStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("CareerStorage"), CareerStorageContract.address, { from: account });

  await deployer.deploy(WorkerServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("WorkerService"), WorkerServiceContract.address, { from: account });

  await deployer.deploy(WorkerStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("WorkerStorage"), WorkerStorageContract.address, { from: account });

  await deployer.deploy(CertificateServiceContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("CertificateService"), CertificateServiceContract.address, { from: account });

  await deployer.deploy(CertificateStorageContract, DispatcherDeployed.address);
  await DispatcherDeployed.importAddress(web3.utils.fromAscii("CertificateStorage"), CertificateStorageContract.address, { from: account });
}

module.exports = migration

export {}
