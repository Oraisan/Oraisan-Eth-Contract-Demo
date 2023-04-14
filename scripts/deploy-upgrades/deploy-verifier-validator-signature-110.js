const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorSignature_110");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorSignature dedployed at: ", verifier.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


