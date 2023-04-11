const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const ProcessString = await ethers.getContractFactory("ProcessString");
    const processString = await upgrades.deployProxy(ProcessString,[]);
    await processString.deployed();
    console.log("ProcessString dedployed at: ", processString.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

