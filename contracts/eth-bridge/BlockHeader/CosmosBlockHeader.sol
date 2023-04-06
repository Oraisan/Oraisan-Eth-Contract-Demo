// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../utils/AVL_Tree.sol";
import {IVerifier} from "../../interface/IVerifier.sol";
import {ICosmosValidators} from "../../interface/ICosmosValidators.sol";
import {IAVL_Tree} from "../../interface/IAVL_Tree.sol";

import "../../libs/Lib_AddressResolver.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CosmosBlockHeader is
    Lib_AddressResolver,
    AVL_Tree,
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
        uint32 _merkleTreeHeight
    ) public initializer {
        require(
            levels == 0 && address(libAddressManager) == address(0),
            "KYC already initialize"
        );

        __Lib_AddressResolver_init(_libAddressManager);
        __AVL_Tree_init(_merkleTreeHeight);
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

    function updateDataHash(
        uint256 _height,
        bytes memory _dataHash
    ) external {
        require(msg.sender == resolve("OraisanGate"), "invalid sender");
        require(dataHashAtHeight[_height].length == 0, "datahash is existed");
        // require(keccak256(blockHash) == keccak256(calulateLRootBySiblings(_dataHash, _siblings)), "invalid datahash");
        dataHash = _dataHash;
        dataHashAtHeight[_height] = _dataHash;
    }

    function updateBlockHash(
        uint256 _height,
        bytes memory _blockHash
    ) external {
        require(msg.sender == resolve("OraisanGate"), "invalid sender");
        require(_height == ICosmosValidators(resolve("CosmosValidator")).getCurrentBlockHeight(), "invalid  height header");
        require(blockHashAtHeight[_height].length == 0, "blockHash is existed");
        currentHeight = _height;
        blockHash = _blockHash;
        blockHashAtHeight[_height] = blockHash;
    }

    function cdcEncode(
        bytes memory _str
    ) public view returns(bytes memory) {
        return _str;
    }

    function createLeaf(
        bytes memory _headerAttribute
    ) public returns(bytes memory) {
        return IAVL_Tree(resolve("AVL_Tree")).hashLeaf(cdcEncode(_headerAttribute));
    }

    function verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) external view returns (bool) {
        // require(
        //     isKnownRootRevoke(uint256(input[0])) &&
        //         isKnownRootClaim(uint256(input[1])),
        //     "Cannot find your merkle root"
        // ); // Make sure to use a recent one

        // require(
        //     block.timestamp <= input[input.length - 1],
        //     "Proof is expired time!"
        // );
        return _verifyProof(_optionName, pi_a, pi_b, pi_c, input);
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

    function getCurrentBlockHeight() public view returns(uint256) {
        return currentHeight;
    }

    function getCurrentBlockHash() public view returns(bytes memory) {
        return blockHash;
    }

    function getBlockHash(uint256 _height) public view returns(bytes memory) {
        return blockHashAtHeight[_height];
    }

    function getCurrentDataHash() public view returns(bytes memory) {
        return dataHash;
    }

    function getDataHash(uint256 _height) public view returns(bytes memory) {
        return dataHashAtHeight[_height];
    }
}
