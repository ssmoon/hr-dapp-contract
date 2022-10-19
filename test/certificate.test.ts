import fs from 'fs'
import { FacadeContract, FacadeInstance } from '../types/truffle-contracts';
const {
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FacadeContract = artifacts.require('Facade')

contract("worker's certificate acquired log", accounts => {
  const ownerAddr = accounts[0];
  const privilegedAddr = accounts[1];
  const testWorker = {
    securityNo: web3.utils.soliditySha3("1101181995111811415") as string,
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
    await facade.createWorker(testWorker, { from: privilegedAddr });
  })

  it("should create a certificate and fetch the one", async () => {
    await facade.createCertificate(testWorker.securityNo, {
      certCode: web3.utils.padRight(web3.utils.asciiToHex("Electrician"), 64),
      acquiredAt: 2019
    }, { from: privilegedAddr })
    const certificates = await facade.getCertificateBySecurityNo(testWorker.securityNo);
    expect(certificates.length).to.equal(1);
    expect(certificates[certificates.length - 1].certCode).to.equal(web3.utils.padRight(web3.utils.asciiToHex("Electrician"), 64));
  })

});