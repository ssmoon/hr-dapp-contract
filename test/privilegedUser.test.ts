import fs from 'fs'
import { FacadeContract, FacadeInstance } from '../types/truffle-contracts';
const {
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FacadeContract = artifacts.require('Facade')

contract("privileged user management, including create, remove and access control", accounts => {
  const ownerAddr = accounts[0];
  const privilegedAddr = accounts[1];
  const strangerAddr = accounts[2];

  let proxyAddr: string;
  let facade: FacadeInstance;
  before(async () => {
    const deployedConfig = JSON.parse(fs.readFileSync("output/deployed.json", 'utf-8'));
    proxyAddr = deployedConfig.proxyedAddr.proxy;
    facade = await FacadeContract.at(proxyAddr);
  })

  it("ping with no restirction", async () => {
    const result = await facade.ping();
    expect(web3.utils.hexToUtf8(result)).to.equal("pong")
  })

  it("require addr to be owner, but it does not", async () => {
    await expectRevert.unspecified(
      facade.pingByOwner({ from: strangerAddr })
    );
  })

  it("use owner addr to visit onlyOwner function", async () => {
    const result = await facade.pingByOwner({ from: ownerAddr });
    expect(web3.utils.hexToUtf8(result)).to.equal("pong");
  })

  it("require addr to be privileged user, but it does not", async () => {
    await expectRevert.unspecified(
      facade.pingByPrivilegedUser()
    );
  })

  it("grant addr to be privileged, then it could visit the function", async () => {
    await facade.createUser(privilegedAddr, { from: ownerAddr });
    const result = await facade.pingByPrivilegedUser({ from: privilegedAddr });
    expect(web3.utils.hexToUtf8(result)).to.equal("pong");
  })

  it("remove addr from privileged list, then it fails to visit the function", async () => {
    await facade.removeUser(privilegedAddr, { from: ownerAddr });
    await expectRevert.unspecified(
      facade.pingByPrivilegedUser({ from: privilegedAddr })
    );
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
