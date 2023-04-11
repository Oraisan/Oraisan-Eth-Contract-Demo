exports.convertUint8Array32ToBytes = exports.convertBytesToUint8Array32 = exports.compareBytesArray32 = exports.sovInt = exports.encodeSovInt = void 0;
const { rdOwnerProcessString } = require("./rdOwner");
require("dotenv").config();

const convertUint8Array32ToBytes = async (uint8Array) => {
    const rdOwner = await rdOwnerProcessString();
    const bytes = await rdOwner.convertUint8Array32ToBytes(uint8Array);
    return bytes;
}
exports.convertUint8Array32ToBytes = convertUint8Array32ToBytes;

const convertBytesToUint8Array32 = async (bytes) => {
    const rdOwner = await rdOwnerProcessString();
    const uint8Array = await rdOwner.convertBytesToUint8Array32(bytes);
    return uint8Array;
}
exports.convertBytesToUint8Array32 = convertBytesToUint8Array32;

const compareBytesArray32 = async (a, b) => {
    const rdOwner = await rdOwnerProcessString();
    const isEqual = await rdOwner.compareBytesArray32(a, b);
    return isEqual;
}
exports.compareBytesArray32 = compareBytesArray32;

const sovInt = async (a) => {
    const rdOwner = await rdOwnerProcessString();
    const nBytes = await rdOwner.sovInt(a);
    return nBytes;
}
exports.sovInt = sovInt;

const encodeSovInt = async (a) => {
    const rdOwner = await rdOwnerProcessString();
    const bytes = await rdOwner.encodeSovInt(a);
    return bytes;
}
exports.encodeSovInt = encodeSovInt;