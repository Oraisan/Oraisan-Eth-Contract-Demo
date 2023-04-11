exports.setLib_AddressManager = exports.getLib_AddressManager = void 0;
const {rdOwnerLib_AddressManager } = require("./rdOwner");
require("dotenv").config();

const setLib_AddressManager = async (optionName, address) => {
    const rdOwner = await rdOwnerLib_AddressManager();
    if(await getLib_AddressManager(optionName) !== address) {
        let setAddress = await rdOwner.setAddress(optionName, address, {gasLimit: BigInt(1e7)});
        await setAddress.wait();
    }
    return await getLib_AddressManager(optionName);
};
exports.setLib_AddressManager = setLib_AddressManager;

const getLib_AddressManager = async (optionName) => {
    const rdOwner = await rdOwnerLib_AddressManager();
    const address = await rdOwner.getAddress(optionName);
    return address;
};
exports.getLib_AddressManager = getLib_AddressManager;