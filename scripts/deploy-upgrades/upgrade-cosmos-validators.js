const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const CosmosValidators = await ethers.getContractFactory("CosmosValidators");
    console.log(
        await upgrades.upgradeProxy(
            process.env.COSMOS_VALIDATORS,
            CosmosValidators
        )
    );

    console.log("CosmosValidators upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

