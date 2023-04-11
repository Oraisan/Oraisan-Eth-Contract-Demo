// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../../interface/IVerifier.sol";
import {IAVL_Tree} from "../../interface/IAVL_Tree.sol";
import {ICosmosValidators} from "../../interface/ICosmosValidators.sol";
import {IAVL_Tree} from "../../interface/IAVL_Tree.sol";

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
    uint256 private currentHeight;
    bytes private blockHash;
    bytes private dataHash;
    bytes private validatorHash;

    mapping(uint256 => bytes) public dataHashAtHeight;
    mapping(uint256 => bytes) public blockHashAtHeight;

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
        bytes memory _blockHash,
        bytes memory _dataHash,
        bytes memory _validatorHash
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

    function updateDataHash(uint256 _height, bytes memory _dataHash) external {
        require(msg.sender == resolve("ORAISAN_GATE"), "invalid sender");
        require(dataHashAtHeight[_height].length == 0, "datahash is existed");
        // require(keccak256(blockHash) == keccak256(calulateLRootBySiblings(_dataHash, _siblings)), "invalid datahash");
        dataHash = _dataHash;
        dataHashAtHeight[_height] = _dataHash;
    }

    function updateBlockHash(
        uint256 _height,
        bytes memory _blockHash
    ) external {
        require(msg.sender == resolve("ORAISAN_GATE"), "invalid sender");
        require(
            _height ==
                ICosmosValidators(resolve("COSMOS_VALIDATORS"))
                    .getCurrentBlockHeight(),
            "invalid  height header"
        );
        require(blockHashAtHeight[_height].length == 0, "blockHash is existed");
        currentHeight = _height;
        blockHash = _blockHash;
        blockHashAtHeight[_height] = blockHash;
    }

    /*  ╔══════════════════════════════╗
        ║        ENCODE FUNCTIONS       ║
        ╚══════════════════════════════╝       */

    function cdcEncode(bytes memory _str) public pure returns (bytes memory) {
        return _str;
    }

    function createLeaf(
        bytes memory _headerAttribute
    ) public view returns (bytes memory) {
        return
            IAVL_Tree(resolve("AVL_TREE")).hashLeaf(
                cdcEncode(_headerAttribute)
            );
    }

    /*  ╔══════════════════════════════╗
        ║        VERIFY FUNCTIONS      ║
        ╚══════════════════════════════╝       */
    function verifyDataAndValsHash(
        IVerifier.DataAndValsHashProof memory _dataAndValsHashProof,
        uint8[32] memory _dataHash,
        uint8[32] memory _validatorHash,
        uint8[32] memory _blockHash
    ) public view returns (bool) {
        string memory optionName = _dataAndValsHashProof.optionName;

        uint[2] memory a = _dataAndValsHashProof.pi_a;
        uint[2][2] memory b = _dataAndValsHashProof.pi_b;
        uint[2] memory c = _dataAndValsHashProof.pi_c;
        uint256[] memory input = new uint256[](96);
        for (uint256 i = 0; i < 32; i++) {
            input[i] = _dataHash[i];
            input[i + 32] = _validatorHash[i];
            input[i + 64] = _blockHash[i];
        }
        return _verifyProof(optionName, a, b, c, input);
    }

    function _verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) internal view returns (bool) {
        return
            IVerifier(resolve(_optionName)).verifyProof(
                pi_a,
                pi_b,
                pi_c,
                input
            );
    }

    /*  ╔══════════════════════════════╗
        ║         GET FUNCTIONS        ║
        ╚══════════════════════════════╝       */

    function getCurrentBlockHeight() public view returns (uint256) {
        return currentHeight;
    }

    function getCurrentBlockHash() public view returns (bytes memory) {
        return blockHash;
    }

    function getBlockHash(uint256 _height) public view returns (bytes memory) {
        return blockHashAtHeight[_height];
    }

    function getCurrentDataHash() public view returns (bytes memory) {
        return dataHash;
    }

    function getDataHash(uint256 _height) public view returns (bytes memory) {
        return dataHashAtHeight[_height];
    }
}
