import fs from 'fs'
import { FacadeContract, FacadeInstance } from '../types/truffle-contracts';
const {
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FacadeContract = artifacts.require('Facade')

contract("worker maintenance, persistent worker general info on the chain", accounts => {
  const ownerAddr = accounts[0];
  const privilegedAddr = accounts[1];
  const testWorker = {
    securityNo: web3.utils.padRight(web3.utils.asciiToHex("1101081995111811415"), 64),
    graduatedAt: 2014,
    birthAt: 1995,
    collegeCode: web3.utils.padRight(web3.utils.asciiToHex("DUT"), 64),
    isValue: true
  }
  let proxyAddr: string;
  let facade: FacadeInstance;
  before(async () => {
    const deployedConfig = JSON.parse(fs.readFileSync("output/deployed.json", 'utf-8'));
    proxyAddr = deployedConfig.proxyedAddr.proxy;
    facade = await FacadeContract.at(proxyAddr);
    await facade.createUser(privilegedAddr, { from: ownerAddr });
  })

  it("should create new worker with unique securityNo", async () => {
    await facade.createWorker(testWorker, { from: privilegedAddr });
    const existWorker = await facade.getWorkerBySecurityNo(testWorker.securityNo);
    expect(existWorker.securityNo).to.equal(testWorker.securityNo);
  })

  it("should revert duplicate securityNo", async () => {
    await expectRevert.unspecified(
      facade.createWorker(testWorker, { from: privilegedAddr })
    );
  })
})