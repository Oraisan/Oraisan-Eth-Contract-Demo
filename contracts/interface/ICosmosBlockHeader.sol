// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ICosmosBlockHeader {
    struct Header {
        uint256 height;
        bytes blockHash;
        uint256 blockTime;
        bytes dataHash;
        bytes validatorHash;
    }

    struct Proof {
        string _optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint[] input;
    }

    function updateDataHash(
        uint256 _height,
        bytes memory _dataHash
    ) external;
    
    function updateBlockHash(
        uint256 _height,
        bytes memory _blockHash
    ) external;

    function cdcEncode(
        bytes memory _str
    ) external view returns(bytes memory);

    function createLeaf(
        bytes memory _headerAttribute
    ) external returns(bytes memory);

    function verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) external view returns (bool);

    function getCurrentBlockHeight() external view returns(uint256);

    function getCurrentBlockHash() external view returns(bytes memory) ;

    function getBlockHash(uint256 _height) external view returns(bytes memory) ;

    function getCurrentDataHash() external view returns(bytes memory) ;

    function getDataHash(uint256 _height) external view returns(bytes memory) ;
}