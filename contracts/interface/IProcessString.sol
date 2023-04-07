// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IProcessString {
    function convertUint8Array32ToBytes(uint8[32] memory _bytesArray) external returns(bytes memory);

    function convertBytesToUint8Array32(bytes memory _bytes) external returns(uint8[32] memory);

    function compareBytesArray(
        uint8[] memory _a,
        uint8[] memory _b
    ) external returns (bool);
}
