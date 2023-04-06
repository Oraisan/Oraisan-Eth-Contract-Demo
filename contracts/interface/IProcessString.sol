// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IProcessString {
    function convertBytesArrayToBytes(uint8[32] memory _bytesArray) external returns(bytes memory);

    function compareBytesArray(
        uint8[] memory _a,
        uint8[] memory _b
    ) external returns (bool);
}
