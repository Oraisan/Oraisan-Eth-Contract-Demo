// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosBlockHeader is IVerifier {
    struct Header {
        uint256 height;
        uint160 blockHash;
        uint256 blockTime;
        uint160 dataHash;
        uint160 validatorHash;
    }

    function updateDataHash(uint256 height, uint160 dataHash) external;

    function updateBlockHash(uint256 height, uint160 blockHash) external;

    function getCurrentBlockHeight() external view returns (uint256);

    function getCurrentBlockHash() external view returns (uint160);

    function getBlockHash(uint256 height) external view returns (uint160);

    function getCurrentDataHash() external view returns (uint160);

    function getDataHash(uint256 height) external view returns (uint160);
}
