// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IAVL_Tree {
    struct ProofPath {
        uint256 _leaf;
        uint256[] _siblings;
    }

    function hashLeaf(bytes memory _leaf) external returns(bytes memory);

    function hashInside(bytes memory _leafLeft, bytes memory _leafRight) external returns(bytes memory);

    function calculateRootByLeafs(bytes[] memory _leafs) external returns(bytes memory);

    function calulateLRootBySiblings(bytes memory _leaf, bytes[] memory _siblings) external returns(bytes memory);
}
