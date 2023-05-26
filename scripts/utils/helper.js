
exports.getAddresFromHexString = exports.hashHexStringWithSHA256 = exports.hexStringToBytes = exports.readJsonFile = exports.byteArrayToHexString = exports.writeToEnvFile = void 0;

const crypto = require('crypto');
const fs = require("fs");

const readJsonFile = (path) => {
    const jsonData = fs.readFileSync(path, 'utf-8');
    const parsedData = JSON.parse(jsonData);
    return parsedData;
}
exports.readJsonFile = readJsonFile;

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
    return "0x" + hash.slice(0, 40).toUpperCase()
}
exports.getAddresFromHexString = getAddresFromHexString;

const byteArrayToHexString = (byteArray) => {
    let hexString = '';
    for (let i = 0; i < byteArray.length; i++) {
        const hex = (byteArray[i] & 0xFF).toString(16);
        hexString += (hex.length === 1 ? '0' : '') + hex;
    }
    return hexString;
}
exports.byteArrayToHexString = byteArrayToHexString;

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
