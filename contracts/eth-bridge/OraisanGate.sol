// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./utils/AVL_Tree.sol";
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
    AVL_Tree,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
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

    function updateblockHeader(
        // ICosmosBlockHeader.Header memory _newBlockHeader,
        bytes[] memory _siblings,
        ICosmosValidators.Validator[] memory _validatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _PMul1Proof,
        IVerifier.EncodeMessageProof memory _encodeMessageProof
    ) external whenNotPaused {
        uint256 lenValidator = _validatorSet.length;
        uint256 lenSig = _AddRHProof.length;
        uint256 lenFnc = _encodeMessageProof.mess.length;
        uint256 i;

        require(_AddRHProof.length == _PMul1Proof.length, "invalid proof");
        require(
            lenSig <= lenValidator,
            "invalid validatorSet or validator sigs"
        );
        require(lenSig <= lenFnc, "invalid num fnc");

        if (lenSig < lenFnc) {
            require(
                _encodeMessageProof.mess[lenSig].fnc == 0,
                "invalid fnc value"
            );
        }

        // require(_newBlockHeader.height == _encodeMessageProof.height, "invalid new height");
        // require(
        //     keccak256(
        //         IProcessString(resolve("Convert")).convertBytesArrayToBytes(
        //             _encodeMessageProof.blockHash
        //         )
        //     ) == keccak256(_newBlockHeader.blockHash),
        //     "invalid blockHash"
        // );

        require(
            ICosmosValidators(resolve("CosmosValidator"))
                .verifyEncodeMessageProof(_encodeMessageProof),
            "invalid encodemessage proof!"
        );

        for (i = 0; i < lenSig; i++) {
            require(
                IProcessString(resolve("convert")).compareBytesArray(
                    _encodeMessageProof.mess[i].message,
                    _AddRHProof[i].message
                ),
                "invalid signature message"
            );
        }

        // uint256 validatorHash = IAVL_Tree(resolve("IAVL_Tree")).calculateRootByLeafs()
        // require(
        //     ICosmosValidators(resolve("CosmosValidator")).verifyNewHeader(
        //         _newBlockHeader.validatorHash,
        //         _validatorSet,
        //         _AddRHProof,
        //         _PMul1Proof
        //     ),
        //     "invalid validator signature"
        // );
  
        // bytes memory L = ICosmosBlockHeader(resolve("CosmosBlockHeader")).createLeaf(_newBlockHeader.dataHash);
        // bytes memory R = ICosmosBlockHeader(resolve("CosmosBlockHeader")).createLeaf(_newBlockHeader.validatorHash);
        // bytes memory parrent = IAVL_Tree(resolve("AVL_Tree")).hashInside(L, R);
        // bytes memory root = IAVL_Tree(resolve("AVL_Tree")).calulateLRootBySiblings(parrent, _siblings);
        // require(keccak256(root) == keccak256(_newBlockHeader.blockHash),"invalid blockHash");
        // ICosmosValidators(resolve("CosmosValidator")).updateValidatorSet(_newBlockHeader.height, _validatorSet);
        // ICosmosBlockHeader(resolve("CosmosBlockheader")).updateBlockHash(_newBlockHeader.height, _newBlockHeader.blockHash);
        // ICosmosBlockHeader(resolve("CosmosBlockheader")).updateDataHash(_newBlockHeader.height, _newBlockHeader.dataHash);
    }

    /*  ╔══════════════════════════════╗
      ║        USERS FUNCTIONS       ║
      ╚══════════════════════════════╝ */
}
