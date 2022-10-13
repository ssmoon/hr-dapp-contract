const ProxyContract = artifacts.require('Proxy')

import { setupLoader } from '@openzeppelin/contract-loader';
import Web3 from 'web3';
import HDWalletProvider from '@truffle/hdwallet-provider';

const mnemonic = "jelly relax fury visit snap quote beyond cross dynamic major toe behind";
const provider = new HDWalletProvider(mnemonic, "HTTP://127.0.0.1:8545");
const loader = setupLoader({ provider: new Web3(provider) }).web3;

import { FacadeInstance } from "../types/truffle-contracts/Facade"

contract("restricted user management, including create, remove and its access restriction", accounts => {
  let facadeInstance: any;
  // set owner addr, always the first account in accounts, consistent with the migration file
  const ownerAddr = accounts[0];
  before(async function () {
    const proxyInstance = await ProxyContract.deployed();
    facadeInstance = loader.fromArtifact('Facade', proxyInstance.address);
  });

  it("should put 10000 MetaCoin in the first account", async () => {
    //const testAccount = accounts[1];
    const result = await facadeInstance.methods.ping().call();
    console.log("[" + web3.utils.toAscii(result) + "]")
    expect(web3.utils.hexToUtf8(result)).to.equal("pong")
  });
})