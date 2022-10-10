const ProxyContract = artifacts.require('Proxy')
const DispatcherContract = artifacts.require('Dispatcher')
const FacadeContract = artifacts.require('Facade')


const UserServiceContract = artifacts.require('UserService')
const UserStorageContract = artifacts.require('UserStorage')

const migration: Truffle.Migration = async function (deployer, network, accounts) {
  const account = accounts[0];

  deployer.deploy(ProxyContract)
  const ProxyDeployed = await ProxyContract.deployed();

  deployer.deploy(DispatcherContract, ProxyDeployed.address);
  const DispatcherDeployed = await DispatcherContract.deployed();

  deployer.deploy(FacadeContract, DispatcherDeployed.address, account);
  const FacadeDeployed = await FacadeContract.deployed();
  
  deployer.deploy(UserServiceContract, DispatcherDeployed.address);
  const UserServiceDeployed = await UserServiceContract.deployed();
  
  
  deployer.deploy(UserStorageContract, DispatcherDeployed.address);
  const UserStorageDeployed = await UserStorageContract.deployed();
  const s = UserStorageDeployed.getContractName();
}

module.exports = migration

export { }