// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Lib_TMHash.sol";
import "hardhat/console.sol";

contract AVL_Tree is Initializable {
    struct ProofPath {
        uint256 _leaf;
        uint256[] _siblings;
    }

    bool isDeployed;

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize() public initializer {
        require(!isDeployed, "ProcessString is deployed");
        isDeployed = true;
    }

    /*  ╔══════════════════════════════╗
      ║        ADMIN FUNCTIONS       ║
      ╚══════════════════════════════╝ */

    function hashLeaf(bytes memory _leaf) public pure returns (bytes memory) {
        return TMHash.leafHash(_leaf);
    }

    function hashInside(
        bytes memory _leafLeft,
        bytes memory _leafRight
    ) public pure returns (bytes memory) {
        return TMHash.innerHash(_leafLeft, _leafRight);
    }

    function calculateRootByLeafs(
        bytes[] memory _leafs
    ) public view returns (bytes memory) {
        uint256 len = _leafs.length;
        if (len == 0) return TMHash.bytes32ToBytes(TMHash.emptyHash());
        if (len == 1) return TMHash.leafHash(_leafs[0]);
        uint256 k = TMHash.getSplitPoint(len);
        return
            hashInside(
                calculateRootByLeafs(TMHash.slice(_leafs, 0, k)),
                calculateRootByLeafs(TMHash.slice(_leafs, k, len))
            );
    }

    function calulateRootBySiblings(
        uint256 _index,
        uint256 _total,
        bytes memory _leaf,
        bytes[] memory _siblings
    ) public view returns (bytes memory) {
        if (_index > _total) return "";
        require(_total > 0, "total should be greater than 0");
        uint256 len = _siblings.length;
        if (_total == 1) {
            if (len != 0) return "";
            return _leaf;
        }
        if (len == 0) return "";
        uint256 numLeft = TMHash.getSplitPoint(_total);
        if (_index < numLeft) {
            bytes memory leftHash = calulateRootBySiblings(
                _index,
                numLeft,
                _leaf,
                TMHash.slice(_siblings, 0, len - 1)
            );
            if (TMHash.bytesEqual(leftHash, "")) {
                return "";
            }
            return hashInside(leftHash, _siblings[len - 1]);
        }
        if (_index < numLeft || _total < numLeft) return "";
        bytes memory rightHash = calulateRootBySiblings(
            _index - numLeft,
            _total - numLeft,
            _leaf,
            TMHash.slice(_siblings, 0, len - 1)
        );
        if (TMHash.bytesEqual(rightHash, "")) {
            return "";
        }
        return hashInside(_siblings[len - 1], rightHash);
    }
}
