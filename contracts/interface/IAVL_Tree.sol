// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IAVL_Tree {
    struct ProofPath {
        uint256 index;
        uint256 total;
        bytes leaf;
        bytes[] siblings;
    }

    function hashLeaf(bytes memory _leaf) external pure returns (bytes memory);

    function hashInside(
        bytes memory _leafLeft,
        bytes memory _leafRight
    ) external pure returns (bytes memory);

    function calculateRootByLeafs(
        bytes[] memory _leafs
    ) external returns (bytes memory);

    function calulateRootBySiblings(
        uint256 _index,
        uint256 _total,
        bytes memory _leaf,
        bytes[] memory _siblings
    ) external returns (bytes memory);
}
