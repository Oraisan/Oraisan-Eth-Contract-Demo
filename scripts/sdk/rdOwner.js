exports.owner = exports.rdOwnerLib_AddressManager = void 0;
const { ethers } = require("hardhat");
require("dotenv").config();

const getOwner = () => {
    return new ethers.Wallet(process.env.PRIVATE_KEY, ethers.provider);
}
const owner = getOwner();
exports.owner = owner;


const rdOwnerLib_AddressManager = async () => {
    const RandLib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    const rdLib_AddressManager = await RandLib_AddressManager.attach(process.env.Lib_AddressManager);
    const rdOwnerLib_AddressManager = await rdLib_AddressManager.connect(owner);
    return rdOwnerLib_AddressManager;
}
exports.rdOwnerLib_AddressManager = rdOwnerLib_AddressManager;
