const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const OraisanGate = await ethers.getContractFactory("OraisanGate");
    console.log(
        await upgrades.upgradeProxy(
            process.env.ORAISAN_GATE,
            OraisanGate
        )
    );

    console.log("OraisanGate upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

