const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const OraisanGate = await ethers.getContractFactory("OraisanGate");
    const oraisanGate = await upgrades.deployProxy(OraisanGate,
        [
            process.env.Lib_AddressManager
        ]);
    await oraisanGate.deployed();
    console.log("OraisanGate dedployed at: ", oraisanGate.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

