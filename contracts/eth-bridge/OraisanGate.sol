// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./utils/AVL_Tree.sol";
import {IVerifier} from "../interface/IVerifier.sol";
import {ICosmosValidators} from "../interface/ICosmosValidators.sol";
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
        uint256 _newHeight,
        bytes memory _newBlockHash,
        bytes memory _newValidatorHash,
        bytes memory _newDataHash,
        ICosmosValidators.Validator[] memory _validatorSet,
        IVerifer.AddCalculateAddRHProof[] memory _addCalculate,
        IVerifier.VerifyPMul1Proof[] memory _verifyPMul1Proof,
        IVerifier.EncodeMessageProof memory _encodeMessageProof
    ) external whenNotPaused returns (bool) {
        uint256 lenValidator = _validatorSet.length;
        uint256 lenFnc = _encodeMessageProof.message.length;
        uint256 height = _encodeMessageProof.height;
        bytes[32] memory blockHash = _encodeMessageProof.blockHash;

        for(uint256 i = 0; i < lenFnc; i++) {
            if (_encodeMessageProof.message[i].fnc != 0) {
                
            }
        }
    }

    /*  ╔══════════════════════════════╗
      ║        USERS FUNCTIONS       ║
      ╚══════════════════════════════╝ */

}
