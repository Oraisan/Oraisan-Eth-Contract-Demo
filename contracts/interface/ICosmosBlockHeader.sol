// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosBlockHeader is IVerifier {
    struct Header {
        uint256 height;
        bytes blockHash;
        uint256 blockTime;
        bytes dataHash;
        bytes validatorHash;
    }

    function updateDataHash(uint256 _height, bytes memory _dataHash) external;

    function updateBlockHash(uint256 _height, bytes memory _blockHash) external;

    function cdcEncode(bytes memory _str) external view returns (bytes memory);

    function createLeaf(
        bytes memory _headerAttribute
    ) external returns (bytes memory);

    function verifyDataAndValsHash(
        IVerifier.DataAndValsHashProof memory _dataAndValsHashProof,
        uint8[32] memory _dataHash,
        uint8[32] memory _validatorHash,
        uint8[32] memory _blockHash
    ) external view returns (bool);

    function getCurrentBlockHeight() external view returns (uint256);

    function getCurrentBlockHash() external view returns (bytes memory);

    function getBlockHash(uint256 _height) external view returns (bytes memory);

    function getCurrentDataHash() external view returns (bytes memory);

    function getDataHash(uint256 _height) external view returns (bytes memory);
}
