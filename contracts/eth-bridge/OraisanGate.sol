// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../interface/IVerifier.sol";
import {ICosmosValidators} from "../interface/ICosmosValidators.sol";
import {IProcessString} from "../interface/IProcessString.sol";
import {IAVL_Tree} from "../interface/IAVL_Tree.sol";
import "../libs/Lib_AddressResolver.sol";

import {ICosmosBlockHeader} from "../interface/ICosmosBlockHeader.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract OraisanGate is
    Lib_AddressResolver,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/
    event BlockHeaderUpdated(
        uint256 blockHeight,
        bytes blockHash,
        address updater
    );
    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/
    uint256 status;

    function initialize(address _libAddressManager) public initializer {
        require(status == 0, "OraisanGate is deployed");
        status = 1;
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

    function updateblockHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        bytes[] memory _siblingsDataAndValPath,
        ICosmosValidators.Validator[] memory _validatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external whenNotPaused {
        require(
            ICosmosValidators(resolve("COSMOS_VALIDATORS")).verifyNewHeader(
                _newBlockHeader,
                _validatorSet,
                _signatureValidatorProof
            ),
            "invalid validator signature"
        );

        uint256 height = _newBlockHeader.height;

        bytes memory L = ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
            .createLeaf(_newBlockHeader.dataHash);
        bytes memory R = ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
            .createLeaf(_newBlockHeader.validatorHash);
        bytes memory parrent = IAVL_Tree(resolve("AVL_TREE")).hashInside(L, R);
        bytes memory root = IAVL_Tree(resolve("AVL_TREE"))
            .calulateRootBySiblings(
                3,
                7,
                parrent,
                _siblingsDataAndValPath
            );
        require(
            keccak256(root) == keccak256(_newBlockHeader.blockHash),
            "invalid blockHash"
        );

        ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSet(
            height,
            _validatorSet
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
            height,
            _newBlockHeader.blockHash
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateDataHash(
            _newBlockHeader.height,
            _newBlockHeader.dataHash
        );

        emit BlockHeaderUpdated(
            _newBlockHeader.height,
            _newBlockHeader.blockHash,
            msg.sender
        );
    }

    function updateblockHeaderV2(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.DataAndValsHashProof memory _dataAndValsHashProof,
        ICosmosValidators.Validator[] memory _validatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external whenNotPaused {
        require(
            ICosmosValidators(resolve("COSMOS_VALIDATORS")).verifyNewHeader(
                _newBlockHeader,
                _validatorSet,
                _signatureValidatorProof
            ),
            "invalid validator signature"
        );

        uint256 height = _newBlockHeader.height;

        uint8[32] memory blockHash = IProcessString(resolve("PROCESS_STRING"))
            .convertBytesToUint8Array32(_newBlockHeader.blockHash);
        uint8[32] memory dataHash = IProcessString(resolve("PROCESS_STRING"))
            .convertBytesToUint8Array32(_newBlockHeader.dataHash);
        uint8[32] memory validatorsHash = IProcessString(
            resolve("PROCESS_STRING")
        ).convertBytesToUint8Array32(_newBlockHeader.validatorHash);

        require(
            ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
                .verifyDataAndValsHash(
                    _dataAndValsHashProof,
                    dataHash,
                    validatorsHash,
                    blockHash
                ),
            "invalid blockHash"
        );

        ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSet(
            height,
            _validatorSet
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
            height,
            _newBlockHeader.blockHash
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateDataHash(
            _newBlockHeader.height,
            _newBlockHeader.dataHash
        );

        emit BlockHeaderUpdated(
            _newBlockHeader.height,
            _newBlockHeader.blockHash,
            msg.sender
        );
    }

    
    /*  ╔══════════════════════════════╗
      ║        USERS FUNCTIONS       ║
      ╚══════════════════════════════╝ */
}
