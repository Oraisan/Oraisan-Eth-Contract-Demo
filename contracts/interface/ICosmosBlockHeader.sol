// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosBlockHeader is IVerifier {
    struct Header {
        uint256 height;
        address blockHash;
        uint256 blockTime;
        address dataHash;
        address validatorHash;
    }

    function updateDataHash(uint256 height, address dataHash) external;

    function updateBlockHash(uint256 height, address blockHash) external;

    function getCurrentBlockHeight() external view returns (uint256);

    function getCurrentBlockHash() external view returns (address);

    function getBlockHash(uint256 height) external view returns (address);

    function getCurrentDataHash() external view returns (address);

    function getDataHash(uint256 height) external view returns (address);
}
