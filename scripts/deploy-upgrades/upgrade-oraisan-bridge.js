const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const OraisanBridge = await ethers.getContractFactory("OraisanBridge");
    console.log(
        await upgrades.upgradeProxy(
            process.env.ORAISAN_BRIDGE,
            OraisanBridge
        )
    );

    console.log("OraisanBridge upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

