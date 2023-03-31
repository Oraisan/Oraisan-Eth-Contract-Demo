pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";


// lib is base on tmHash and IAVLTree hash in tendermint
library Helper {
    bytes constant private leafPrefix = hex"00";
    bytes constant private innerPrefix = hex"01";

    function bytes32ToBytes(bytes32 data) internal pure returns (bytes memory result) {
        assembly {
            result := mload(0x40)
            mstore(result, 0x20)
            mstore(add(result, 0x20), data)
            mstore(0x40, add(result, 0x40))
        }
    }

    function bytesEqual(bytes memory a, bytes memory b) internal pure returns (bool) {
        if (a.length != b.length) {
            return false;
        }
        for (uint i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    function slice(bytes[] memory data, uint256 start, uint256 end) internal pure returns (bytes[] memory) {
        require(end >= start, "Invalid range");
    
        uint256 length = end - start;
        bytes[] memory result = new bytes[](length);
    
        for (uint256 i = 0; i < length; i++) {
            result[i] = data[start + i];
        }
    
        return result;
    }

    function leafHash(bytes memory leaf) public pure returns (bytes memory) {
        bytes memory data = abi.encodePacked(leafPrefix, leaf);
        bytes memory hash = bytes32ToBytes( sha256(data));
        return hash;
    }

    function innerHash(bytes memory left, bytes memory right) public pure returns (bytes memory) {
        bytes memory data = abi.encodePacked(innerPrefix, left, right);
        bytes32 hash = sha256(data);
        bytes memory hashBytes = bytes32ToBytes(hash);
        return hashBytes;
    }


    function sum(bytes memory data) public pure returns (bytes32) {
        return sha256(data);
    }

    function emptyHash() public pure returns (bytes32) {
        // hash of empty string
        return sha256("");
    }

    function getSplitPoint(uint n) public view returns (uint) {
        require(n >= 1, "Trying to split tree with length < 1");
        
        uint mid = 2 ** uint256(Math.log2(n));
        if (mid == n) {
            mid /= 2;
        }
        return mid;
    }

}