pragma solidity 0.8.4;

import "./lib/Helper.sol";
import "hardhat/console.sol";
contract Verify {
    bytes private constant leafPrefix = hex"00";
    bytes private constant innerPrefix = hex"01";

    struct Proof {
        uint256 Total; // Total number of items.
        uint256 Index; // Index of item to prove.
        bytes LeafHash; // Hash of item value.
        bytes[] Aunts; // Hashes from leaf's sibling to a root's child.
    }

    // Verify that the Proof proves the root hash.
    // Check sp.index/sp.total manually if needed
    function verify(
        Proof memory sp,
        bytes memory rootHash,
        bytes memory leaf
    ) public view returns (bool) {
        
        require(sp.Total >= 0, "proof total must be positive");
        require(sp.Index >= 0, "proof index cannot be negative");

        bytes memory hash = Helper.leafHash(leaf);
        // require(sp.LeafHash == hash, "invalid leaf hash");
        require(Helper.bytesEqual(sp.LeafHash, hash), "invalid leaf hash");
        bytes memory computedHash = computeRootHash(
            sp.Index,
            sp.Total,
            sp.LeafHash,
            sp.Aunts
        );
      
        // require(computedHash == rootHash, "invalid root hash");
        require(Helper.bytesEqual(computedHash, rootHash), "invalid root hash");
        return true;
    }

    // Compute the root hash given a leaf hash. Does not verify the result.
    function computeRootHash(
        uint256 index,
        uint256 total,
        bytes memory leafHash,
        bytes[] memory aunts
    ) internal view returns (bytes memory) {
        return computeHashFromAunts(index, total, leafHash, aunts);
    }
    
    function computeHashFromAunts(
        uint256 index,
        uint256 total,
        bytes memory leafHash,
        bytes[] memory innerHashes
    ) internal view returns (bytes memory) {
        require(
            index < total && index >= 0 && total > 0,
            "index out of bounds"
        );
        uint256 numLeft = uint256(Helper.getSplitPoint(total));
        bytes memory hash;
    
        if (total == 1) {
            require(
                innerHashes.length == 0,
                "innerHashes must be empty for single leaf"
            );
            hash = leafHash;
        } else if (innerHashes.length == 0) {
            // If there are no siblings, return the hash of the leaf
            hash = leafHash;
        } else if (index < numLeft) {
            bytes memory leftHash = computeHashFromAunts(
                index,
                numLeft,
                leafHash,
                Helper.slice(innerHashes, 0, innerHashes.length - 1)
            );
            hash = Helper.innerHash(
                leftHash,
                innerHashes[innerHashes.length - 1]
            );
        } else {
            bytes memory rightHash = computeHashFromAunts(
                index - numLeft,
                total - numLeft,
                leafHash,
                Helper.slice(innerHashes, 0, innerHashes.length - 1)
            );
            hash = Helper.innerHash(
                innerHashes[innerHashes.length - 1],
                rightHash
            );
        }
        return hash;
    }
}
