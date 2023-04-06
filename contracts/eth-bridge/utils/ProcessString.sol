// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract AVL_Tree is Initializable {
    function convertBytesArray32ToBytes(
        uint8[32] memory _bytesArray
    ) public pure returns (bytes memory) {
        bytes memory bytesArray = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            bytesArray[i] = bytes1(_bytesArray[i]);
        }
        return abi.encodePacked(bytesArray);
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
