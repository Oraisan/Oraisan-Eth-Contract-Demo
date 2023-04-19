// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../interface/IVerifier.sol";
import {ICosmosValidators} from "../interface/ICosmosValidators.sol";
import {IProcessString} from "../interface/IProcessString.sol";
import {IAVL_Tree} from "../interface/IAVL_Tree.sol";
import "../libs/Lib_AddressResolver.sol";

import "hardhat/console.sol";
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

    mapping (uint256 => ICosmosBlockHeader.Header ) newBlockHeaders;
    mapping (uint256=>ICosmosValidators.Validator[]) validatorSets;
    mapping (uint256 => bool) isVerifieds;

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

    function updateBlockHeader (
        uint256 _blockHeight,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    )external whenNotPaused {
        
        require(isVerifieds[_blockHeight] == false, "Block header is verified");
        require(
            ICosmosValidators(resolve("COSMOS_VALIDATORS")).verifyNewHeader(
               newBlockHeaders[_blockHeight],
                validatorSets[_blockHeight],
                _signatureValidatorProof
            ),
            "invalid validator signature"
        );
        ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSet(
            _blockHeight,
            validatorSets[_blockHeight]
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
            _blockHeight,
            newBlockHeaders[_blockHeight].blockHash
        );
        isVerifieds[_blockHeight] = true;
        emit BlockHeaderUpdated(
            _blockHeight,
            newBlockHeaders[_blockHeight].blockHash,
            msg.sender
        );
    }

    function verifyBlockHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        bytes[] memory _siblingsDataAndValPath,
        ICosmosValidators.Validator[] memory _validatorSet
    ) external whenNotPaused {
        uint256 height = _newBlockHeader.height;

        // // get address of cosmos block header
        // address cosmosBlockHeader = resolve("COSMOS_BLOCK_HEADER");
        // console.log("cosmosBlockHeader", cosmosBlockHeader);

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

        // update blockHeaderPhases
        for (uint256 i = 0; i < _validatorSet.length; i++) {
            validatorSets[height].push(_validatorSet[i]);
        }
        newBlockHeaders[height] = _newBlockHeader;
        isVerifieds[height] = false;

        emit BlockHeaderUpdated(
            _newBlockHeader.height,
            _newBlockHeader.blockHash,
            msg.sender
        );
    }

    // function ac(
    //     ICosmosBlockHeader.Header memory _newBlockHeader,
    //     bytes[] memory _siblingsDataAndValPath,
    //     ICosmosValidators.Validator[] memory _validatorSet,
    //      IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    //  ) public view returns (uint256) {
    //     return 1;
    //  }

    // function updateblockHeaderTest(
    //     ICosmosBlockHeader.Header memory _newBlockHeader,
    //     bytes[] memory _siblingsDataAndValPath,
    //     ICosmosValidators.Validator[] memory _validatorSet,
    //     IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    // ) public whenNotPaused {
    //     // require(
    //     //     ICosmosValidators(resolve("COSMOS_VALIDATORS")).verifyNewHeader(
    //     //         _newBlockHeader,
    //     //         _validatorSet,
    //     //         _signatureValidatorProof
    //     //     ),
    //     //     "invalid validator signature"
    //     // );

    //     // uint256 height = _newBlockHeader.height;

    //     // bytes memory L = ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
    //     //     .createLeaf(_newBlockHeader.dataHash);
    //     // bytes memory R = ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
    //     //     .createLeaf(_newBlockHeader.validatorHash);
    //     // bytes memory parrent = IAVL_Tree(resolve("AVL_TREE")).hashInside(L, R);
    //     // bytes memory root = IAVL_Tree(resolve("AVL_TREE"))
    //     //     .calulateRootBySiblings(
    //     //         3,
    //     //         7,
    //     //         parrent,
    //     //         _siblingsDataAndValPath
    //     //     );
    //     // require(
    //     //     keccak256(root) == keccak256(_newBlockHeader.blockHash),
    //     //     "invalid blockHash"
    //     // );

    //     // ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSet(
    //     //     height,
    //     //     _validatorSet
    //     // );
    //     // ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
    //     //     height,
    //     //     _newBlockHeader.blockHash
    //     // );
    //     // ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateDataHash(
    //     //     _newBlockHeader.height,
    //     //     _newBlockHeader.dataHash
    //     // );

    //     // emit BlockHeaderUpdated(
    //     //     _newBlockHeader.height,
    //     //     _newBlockHeader.blockHash,
    //     //     msg.sender
    //     // );
    // }

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
