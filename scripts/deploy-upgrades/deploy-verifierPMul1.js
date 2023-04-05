const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const Verifier = await ethers.getContractFactory("VerifierPMul1");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierPMul1 dedployed at: ", verifier.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


