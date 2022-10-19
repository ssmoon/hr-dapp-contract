import fs from 'fs'
import { FacadeContract, FacadeInstance } from '../types/truffle-contracts';
const {
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FacadeContract = artifacts.require('Facade')

contract("worker's career experience, log every work period after graduation", accounts => {
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

  it("should create and load work experience", async () => {
    await facade.addWorkExperience(testWorker.securityNo, {
      startAt: 2018,
      endAt: 2019,
      hasEnded: true,
      companyCode: web3.utils.padRight(web3.utils.asciiToHex("NIO"), 64),
    }, { from: privilegedAddr })
    await facade.addWorkExperience(testWorker.securityNo, {
      startAt: 2019,
      endAt: 2020,
      hasEnded: true,
      companyCode: web3.utils.padRight(web3.utils.asciiToHex("chery"), 64),
    }, { from: privilegedAddr })
    const experiences = await facade.getWorkExperienceBySecurityNo.call(testWorker.securityNo);
    expect(experiences.length).to.equal(2);
    expect(experiences[1].companyCode).to.equal(web3.utils.padRight(web3.utils.asciiToHex("chery"), 64));
  })

  it("should finish last work experience", async () => {
    await facade.addWorkExperience(testWorker.securityNo, {
      startAt: 2018,
      endAt: 2020,
      hasEnded: false,
      companyCode: web3.utils.padRight(web3.utils.asciiToHex("chery"), 64),
    }, { from: privilegedAddr })
    await facade.finishLastCareer(testWorker.securityNo, 2020, { from: privilegedAddr });
    const experiences = await facade.getWorkExperienceBySecurityNo.call(testWorker.securityNo);
    expect(experiences[experiences.length - 1].hasEnded).to.equal(true);
  })
})