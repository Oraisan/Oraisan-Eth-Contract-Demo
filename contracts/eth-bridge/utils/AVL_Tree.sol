// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract AVL_Tree is Initializable {

    uint256 public levels;

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function __AVL_Tree_init(uint256 _levels)
        internal
        onlyInitializing
    {
        require(_levels > 0, "_levels should be greater than zero");
        require(_levels < 40, "_levels should be less than 40");
        levels = _levels;
    }

    /*  ╔══════════════════════════════╗
      ║        ADMIN FUNCTIONS       ║
      ╚══════════════════════════════╝ */

    function hashLeaf(bytes memory _leaf) public returns(bytes memory) {
        return "0";
    }

    function hashInside(bytes memory _leafLeft, bytes memory _leafRight) public returns(bytes memory) {
        return "0";
    }

    function calculateRootByLeafs(bytes[] memory _leafs) public returns(bytes memory) {
        return "0";
    }

    function calulateLRootBySiblings(bytes memory _leaf, bytes[] memory _siblings) public returns(bytes memory) {
        return "0";
    }
}
