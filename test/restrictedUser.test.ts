// const ProxyContract = artifacts.require('Proxy')
// import Web3 from 'web3';
// import { setupLoader } from '@openzeppelin/contract-loader';
// // import Web3, { Web3.utils } from 'web3';
// import HDWalletProvider from '@truffle/hdwallet-provider';
// import { FacadeInstance } from '../types/truffle-contracts/Facade';
// const truffleAssert = require('truffle-assertions');
// const mnemonic = "market print rigid attract satoshi choose genuine setup minute artist pottery domain";
// const provider = new HDWalletProvider(mnemonic, "HTTP://127.0.0.1:8545");

import fs from 'fs'

// const loader = setupLoader({ provider: new Web3(provider) }).web3;
const FacadeContract = artifacts.require('Facade')
contract("restricted user management, including create, remove and its access restriction", accounts => {
  let proxyAddr: string;
  before(() => {
    const deployedConfig = JSON.parse(fs.readFileSync("output/deployed.json", 'utf-8'));
    proxyAddr = deployedConfig.proxyed.proxy;
  })

  it("test network", async () => {
    const existing = await FacadeContract.at(proxyAddr);
    const result = await existing.pong();
    console.log(result);
  })
})


/*
contract("restricted user management, including create, remove and its access restriction", accounts => {
  let facadeInstance: any;
  // set owner addr, always the first account in accounts, consistent with the migration file
  const ownerAddr = accounts[0];
  console.log("owner addr is:" + ownerAddr)
  const restrictedAddr = accounts[1];
  const unauthenticatedAccount = accounts[2];
  before(async function () {
    const proxyInstance = await ProxyContract.deployed();
    facadeInstance = loader.fromArtifact('Facade', proxyInstance.address);
  });

  it("can visit facade through proxy fallback", async () => {
    const facadeDeployed = await FacadeContract.deployed();
    const r = await facadeDeployed.pong();
    console.log("1 call result is: " + r)
    //await facadeInstance.methods.createUser(restrictedAddr).call({ from: ownerAddr });
  });

  it("ping", async () => {
    const result = await facadeInstance.methods.ping().call();
    console.log("2 call result is: " + result)
    expect(Web3.utils.hexToUtf8(result)).to.equal("pong")
  });

  it("owner could visit restricted function", async () => {
    const result = await facadeInstance.methods.pong().call();
    console.log("3 call result is: " + result)
    expect(Web3.utils.hexToUtf8(result)).to.equal("pong")
  });

  // it("add user to restircted list, then it can visit restricted function", async () => {
  //   await facadeInstance.methods.createUser(restrictedAddr).call({ from: ownerAddr });
  //   const result = await facadeInstance.methods.pingByUser().call({ from: restrictedAddr });
  //   expect(Web3.utils.hexToUtf8(result)).to.equal("pong")
  // });

  // it("remove user to restircted list, then it cannot visit restricted function", async () => {
  //   await facadeInstance.methods.removeUser(restrictedAddr).call({ from: ownerAddr });
  //   await truffleAssert.reverts(facadeInstance.methods.pingByUser().call({ from: restrictedAddr }));
  // });

  // it("non-authenticated users should not visit restricted function", async () => {
  //   await truffleAssert.reverts(facadeInstance.methods.pingByUser().call({ from: unauthenticatedAccount }));
  // });
})
*/
