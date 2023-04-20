const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const input = {
    lib_AddressManager: process.env.Lib_AddressManager,
    height: 10340037,
    blockHash: "0x4438338076A598D0B4C589E572342130FC5BCD60",
    dataHash: "0x5DF6E0E2761359D30A8275058E299FCC03815345",
    validatorHash: "0x11F6D96C885B3C278D28DBF6892DFC809C4FC399"
}
const main = async () => {
    const CosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
    const cosmosBlockHeader = await upgrades.deployProxy(CosmosBlockHeader,
        [
            input.lib_AddressManager,
            input.height,
            input.blockHash,
            input.dataHash,
            input.validatorHash
        ]);
    await cosmosBlockHeader.deployed();
    console.log("CosmosBlockHeader dedployed at: ", cosmosBlockHeader.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

