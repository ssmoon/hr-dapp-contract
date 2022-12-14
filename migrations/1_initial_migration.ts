const { deployProxy, upgradeProxy, erc1967 } = require('@openzeppelin/truffle-upgrades');
var fs = require('fs');

const DispatcherContract = artifacts.require('Dispatcher')
const FacadeContract = artifacts.require('Facade')

const CareerServiceContract = artifacts.require('CareerService')
const CareerStorageContract = artifacts.require('CareerStorage')

const WorkerServiceContract = artifacts.require('WorkerService')
const WorkerStorageContract = artifacts.require('WorkerStorage')

const CertificateServiceContract = artifacts.require('CertificateService')
const CertificateStorageContract = artifacts.require('CertificateStorage')

const migration: Truffle.Migration = async function (deployer, network, accounts) {
  const account = accounts[0];

  console.log("deploying start with owner account: " + account);

  // contract discovery center
  await deployer.deploy(DispatcherContract);
  const DispatcherDeployed = await DispatcherContract.deployed();

  const proxiedFacade = await deployProxy(FacadeContract, [DispatcherDeployed.address], { deployer, initializer: 'initialize', from: account });
  const adminAdress = (await erc1967.getAdminAddress(proxiedFacade.address));
  const implAddress = (await erc1967.getImplementationAddress(proxiedFacade.address));
  console.log("proxy's address is: " + proxiedFacade.address);
  console.log("proxy's admin address is: " + adminAdress);
  console.log("proxy's implementation address is: " + implAddress);

  const deployResult = {
    ownerAddr: account,
    proxyedAddr: {
      proxy: proxiedFacade.address,
      admin: adminAdress,
      implementation: implAddress
    },
    network: network,
    updated: (new Date()).toLocaleString('cn-ZH')
  };
  fs.writeFileSync('output/deployed.json', JSON.stringify(deployResult, null, 4));

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

export { }
