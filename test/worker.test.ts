import fs from 'fs'
import { FacadeContract, FacadeInstance } from '../types/truffle-contracts';
const {
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FacadeContract = artifacts.require('Facade')

contract("worker maintenance, persistent worker general info on the chain", accounts => {
  const ownerAddr = accounts[0];
  const privilegedAddr = accounts[1];
  const strangerAddr = accounts[2];

  let proxyAddr: string;
  let facade: FacadeInstance;
  before(async () => {
    const deployedConfig = JSON.parse(fs.readFileSync("output/deployed.json", 'utf-8'));
    proxyAddr = deployedConfig.proxyedAddr.proxy;
    facade = await FacadeContract.at(proxyAddr);
    await facade.createUser(privilegedAddr, { from: ownerAddr });
  })

  it("should create new worker with unique securityNo", async () => {

  })

})