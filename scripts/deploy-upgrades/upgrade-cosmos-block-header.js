const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const CosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
    console.log(
        await upgrades.upgradeProxy(
            process.env.COSMOS_BLOCK_HEADER,
            CosmosBlockHeader
        )
    );

    console.log("CosmosBlockHeader upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

