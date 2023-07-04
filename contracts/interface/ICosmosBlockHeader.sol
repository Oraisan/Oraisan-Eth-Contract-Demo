// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosBlockHeader is IVerifier {
    struct Header {
        uint256 height;
        bytes20 blockHash;
        uint256 blockTime;
        bytes20 dataHash;
        bytes20 validatorHash;
    }

    function updateDataHash(uint256 height, bytes20 dataHash) external;

    function updateBlockHash(uint256 height, bytes20 blockHash) external;

    function getCurrentBlockHeight() external view returns (uint256);

    function getCurrentBlockHash() external view returns (bytes20);

    function getBlockHash(uint256 height) external view returns (bytes20);

    function getCurrentDataHash() external view returns (bytes20);

    function getDataHash(uint256 height) external view returns (bytes20);
}
