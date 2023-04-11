const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const input = {
    lib_AddressManager: process.env.Lib_AddressManager,
    height: 10340037,
    blockHash: "0xDDB010FECDA643EFB6E7F0FBCBB0A4AB7F23173F865B40EDF47139A3627E1200",
    dataHash: "0x677BF175DE9C1EDDD2F26AE4161631390A24486D44BBC71982C39965F58967C4",
    validatorHash: "0x1A695B879702E2CBA64500C4717D9A96C951ED2083124F1179B7E7223825EA6D"
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

