
exports.bigNumberToHexString = exports.getAddresFromHexString = exports.hashHexStringWithSHA256 = exports.hexStringToBytes = exports.readJsonFile = exports.byteArrayToHexString = exports.base64ToHex = exports.writeToEnvFile = exports.getAddresFromAsciiString = void 0;

const crypto = require('crypto');
const fs = require("fs");
const { toChecksumAddress } = require('ethereumjs-util');


const readJsonFile = (path) => {
    const jsonData = fs.readFileSync(path, 'utf-8');
    const parsedData = JSON.parse(jsonData);
    return parsedData;
}
exports.readJsonFile = readJsonFile;

const convertHexStringToAddress = (hexString) => {
    const strippedHex = hexString.replace(/^0x/, '');

    return toChecksumAddress(`0x${strippedHex}`);
}
exports.convertHexStringToAddress = convertHexStringToAddress;

const bigNumberToHexString = (input) => {
    const bigNumber = BigInt(input);
    if (typeof bigNumber !== 'bigint') {
      throw new Error("Invalid BigNumber");
    }
    return "0x" + bigNumber.toString(16);
}
exports.bigNumberToHexString = bigNumberToHexString;

const hexStringToBytes = (hexString) => {
    const bytes = [];
    for (let i = 0; i < hexString.length; i += 2) {
        const byte = parseInt(hexString.substr(i, 2), 16);
        bytes.push(byte);
    }
    return bytes;
}
exports.hexStringToBytes = hexStringToBytes;

const hashHexStringWithSHA256 = (hexString) => {
    const bytes = hexStringToBytes(hexString);
    const hash = crypto.createHash('sha256').update(Buffer.from(bytes)).digest('hex');
    return hash;
}
exports.hashHexStringWithSHA256 = hashHexStringWithSHA256;


const getAddresFromHexString = (hexString) => {
    const hash = hashHexStringWithSHA256(hexString)
    return convertHexStringToAddress("0x" + hash.slice(0, 40))
}
exports.getAddresFromHexString = getAddresFromHexString;

const getAddresFromBase64String = (base64String) => {
    const hexString = base64ToHex(base64String);
    const hash = hashHexStringWithSHA256(hexString)
    return "0x" + hash.slice(0, 40)
}
exports.getAddresFromBase64String = getAddresFromBase64String;

const byteArrayToHexString = (byteArray) => {
    let hexString = '';
    for (let i = 0; i < byteArray.length; i++) {
        const hex = (byteArray[i] & 0xFF).toString(16);
        hexString += (hex.length === 1 ? '0' : '') + hex;
    }
    return hexString;
}
exports.byteArrayToHexString = byteArrayToHexString;

const base64ToHex = (str) => {
    const result = Buffer.from(str, 'base64').toString("hex") ;
    return result;
}
exports.base64ToHex = base64ToHex;

function stringToAsciiBytes(str) {
    const bytes = new Uint8Array(str.length);
    for (let i = 0; i < str.length; i++) {
        bytes[i] = str.charCodeAt(i);
    }
    return bytes;
}

function uint8ArrayToHexString(uint8Array) {
    let hexString = "";
    for (let i = 0; i < uint8Array.length; i++) {
      const hex = uint8Array[i].toString(16).padStart(2, "0");
      hexString += hex;
    }
    return hexString;
  }



const getAddresFromAsciiString = (asciiString) => {
    const hexString = uint8ArrayToHexString(stringToAsciiBytes(asciiString));
    const hash = hashHexStringWithSHA256(hexString)
    const address = convertHexStringToAddress("0x" + hash.slice(0, 40))
    return address
}
exports.getAddresFromAsciiString = getAddresFromAsciiString;


const writeToEnvFile = (key, value) => {
    const envFilePath = '.env';
    const envString = `${key}=${value}`;

    try {
        if (fs.existsSync(envFilePath)) {
            let data = fs.readFileSync(envFilePath, 'utf8');
            const lines = data.trim().split('\n');
            let keyExists = false;
            const updatedLines = lines.map(line => {
                const [existingKey] = line.split('=');
                if (existingKey === key) {
                    keyExists = true;
                    return envString;
                }
                return line;
            });
            if (!keyExists) {
                updatedLines.push(envString);
            }
            const updatedData = updatedLines.join('\n');
            fs.writeFileSync(envFilePath, updatedData + '\n');
        } else {
            fs.writeFileSync(envFilePath, envString + '\n');
        }
        console.log('Successfully wrote to .env file.');
    } catch (err) {
        console.error('Error writing to .env file:', err);
    }
}
exports.writeToEnvFile = writeToEnvFile;


