// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract AVL_Tree is Initializable {
    function convertUint8Array32ToBytes(
        uint8[32] memory _uin8Array
    ) public pure returns (bytes memory) {
        bytes memory uin8Array = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            uin8Array[i] = bytes1(_uin8Array[i]);
        }
        return abi.encodePacked(uin8Array);
    }

    function convertBytesToUint8Array32(bytes memory _bytes) public pure returns(uint8[32] memory) {

    }
    
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
}
