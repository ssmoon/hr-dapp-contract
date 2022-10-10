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

  deployer.deploy(FacadeContract, DispatcherDeployed, account);
  const FacadeDeployed = await FacadeContract.deployed();
}

module.exports = migration

// because of https://stackoverflow.com/questions/40900791/cannot-redeclare-block-scoped-variable-in-unrelated-files
export { }