// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../../interface/IVerifier.sol";
import {ICosmosValidators} from "../../interface/ICosmosValidators.sol";

import "../../libs/Lib_AddressResolver.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CosmosBlockHeader is
    Lib_AddressResolver,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    uint256 internal currentHeight;
    bytes20 internal blockHash;
    bytes20 internal dataHash;
    bytes20 internal validatorHash;

    mapping(uint256 => bytes20) public dataHashAtHeight;
    mapping(uint256 => bytes20) public blockHashAtHeight;

    // struct DataHashProof {
    //     uint256 leaf;
    //     uint256[] siblings;
    // }

    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize(
        address _libAddressManager,
        uint256 _height,
        bytes20 _blockHash,
        bytes20 _dataHash,
        bytes20 _validatorHash
    ) public initializer {
        require(currentHeight == 0, "CosmosBlockHeader is initialized");
        currentHeight = _height;
        blockHash = _blockHash;
        dataHash = _dataHash;
        validatorHash = _validatorHash;

        dataHashAtHeight[_height] = _dataHash;
        blockHashAtHeight[_height] = _blockHash;

        __Lib_AddressResolver_init(_libAddressManager);
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Pausable_init_unchained();
        __ReentrancyGuard_init_unchained();
    }

    /**
     * Pause relaying.
     */
    function pause() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }

    /*  ╔══════════════════════════════╗
        ║        ADMIN FUNCTIONS       ║
        ╚══════════════════════════════╝       */

    function updateDataHash(uint256 _height, bytes20 _dataHash) external {
        require(
            msg.sender == resolve("ORAISAN_GATE") || msg.sender == owner(),
            "invalid sender"
        );
        require(dataHashAtHeight[_height] == 0, "datahash is existed");
        // require(keccak256(blockHash) == keccak256(calulateLRootBySiblings(_dataHash, _siblings)), "invalid datahash");
        dataHash = _dataHash;
        dataHashAtHeight[_height] = _dataHash;
    }

    function updateBlockHash(uint256 _height, bytes20 _blockHash) external {
        require(
            msg.sender == resolve("ORAISAN_GATE") || msg.sender == owner(),
            "invalid sender"
        );
        require(
            _height ==
                ICosmosValidators(resolve("COSMOS_VALIDATORS"))
                    .getCurrentBlockHeight(),
            "invalid  height header"
        );
        require(blockHashAtHeight[_height] == 0, "blockHash is existed");
        currentHeight = _height;
        blockHash = _blockHash;
        blockHashAtHeight[_height] = blockHash;
    }

    /*  ╔══════════════════════════════╗
        ║         GET FUNCTIONS        ║
        ╚══════════════════════════════╝       */

    function getCurrentBlockHeight() public view returns (uint256) {
        return currentHeight;
    }

    function getCurrentBlockHash() public view returns (bytes20) {
        return blockHash;
    }

    function getBlockHash(uint256 _height) public view returns (bytes20) {
        return blockHashAtHeight[_height];
    }

    function getCurrentDataHash() public view returns (bytes20) {
        return dataHash;
    }

    function getDataHash(uint256 _height) public view returns (bytes20) {
        return dataHashAtHeight[_height];
    }
}
