// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ProcessString is Initializable {
    bool isDeployed;
    function initialize() public initializer {
        require(!isDeployed, "ProcessString is deployed");
        isDeployed = true;
    }
    
    function convertUint8Array32ToBytes(
        uint8[32] memory _uint8Array
    ) public pure returns (bytes memory) {
        bytes memory uint8Array = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            uint8Array[i] = bytes1(_uint8Array[i]);
        }
        return abi.encodePacked(_uint8Array);
    }

    function convertBytesToUint8Array32(
        bytes memory _bytes
    ) public pure returns (uint8[32] memory) {}

    function compareBytesArray32(
        uint8[] memory _a,
        uint8[] memory _b
    ) public pure returns (bool) {
        require(_a.length == _b.length, "can't compare two array");
        uint256 len = _a.length;
        for (uint256 i = 0; i < len; i++) {
            if (_a[i] != _b[i]) return false;
        }
        return true;
    }

    function sovInt(uint256 a) public pure returns (uint256) {
        uint256 length = 0;
        while (a != 0) {
            a >>= 1;
            length++;
        }
        return (length | (1 + 6)) / 7;
    }

    function encodeSovInt(uint256 a) public pure returns (bytes memory) {
        uint256 offset = 0;
        uint256 len = sovInt(a);
        uint8[] memory dAtA = new uint8[](len);
        while (a >= 1 << 7) {
            dAtA[offset] = uint8((a & 0x7f) | 0x80);
            a >>= 7;
            offset++;
        }
        dAtA[offset] = uint8(a);

        bytes memory uint8Array = new bytes(len);
        for (uint256 i = 0; i < len; i++) {
            uint8Array[i] = bytes1(dAtA[i]);
        }
        return abi.encodePacked(uint8Array);
    }
}
