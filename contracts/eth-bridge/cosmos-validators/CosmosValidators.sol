// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../utils/AVL_Tree.sol";
import {IVerifier} from "../../interface/IVerifier.sol";
import "../../libs/Lib_AddressResolver.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CosmosValidators is
    Lib_AddressResolver,
    AVL_Tree,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    struct Validator {
        address validatorAddress;
        uint256 votingPower;
    }

    // struct ValidatorProof {
    //     uint256 leaf;
    //     uint256[] siblings;
    // }
    uint256 private numValidator;
    uint256 private currentHeight;
    Validator[] private validatorSet;

    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize(
        address _libAddressManager,
        uint256 _currentHeight,
        uint256 _numValidator,
        uint32 _merkleTreeHeight,
        Validator[] memory _validatorSet
    ) public initializer {
        require(
            levels == 0 && address(libAddressManager) == address(0),
            "KYC already initialize"
        );

        require(
            _numValidator == _validatorSet.length,
            "invalid numberValidator"
        );
        currentHeight = _currentHeight;
        numValidator = _numValidator;
        for (uint256 i = 0; i < _numValidator; i++) {
            validatorSet[i] = _validatorSet[i];
        }

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
    function updateValidatorSet(
        uint256 _height,
        Validator[] memory _validatorSet
    ) external {
        require(msg.sender == resolve("OraisanGate"), "invalid sender");
        currentHeight = _height;
        uint256 len = _validatorSet.length;
        for (uint256 i = 0; i < len; i++) {
            validatorSet[i] = _validatorSet[i];
        }
        numValidator = len;
    }

    // bridge validator
    function updateValidatorSetByProof() external {}

    function verifyNewHeader(
        bytes memory _validatorHash,
        Validator[] memory _validatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _verifyPMul1Proof,
        uint8[3][111] memory _validatorSignature
    ) public returns (bool) {
        // require(
        //     verifyValidatorHash(_validatorHash, _validatorSet),
        //     "invalid validator hash"
        // );
        require(
            verifySignaturesHeader(
                _validatorSet,
                _AddRHProof,
                _verifyPMul1Proof,
                _validatorSignature
            ),
            "invalid validator set"
        );
        return true;
    }

    function verifyValidatorHash(
        bytes memory validators_hash,
        Validator[] memory _validatorSet
    ) public returns (bool) {
        uint256 len = _validatorSet.length;
        bytes[] memory validatorSetEncode;

        for (uint256 i = 0; i < len; i++) {
            validatorSetEncode[i] = encodeValidator(_validatorSet[i]);
        }

        return
            keccak256(validators_hash) ==
            keccak256(calculateRootByLeafs(validatorSetEncode));
    }

    function encodeValidator(
        Validator memory _validator
    ) public returns (bytes memory) {
        return bytes("1");
    }

    function verifySignaturesHeader(
        Validator[] memory _newValidatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _verifyPMul1Proof,
        uint8[3][111] memory _message
    ) public returns (bool) {
        require(
            _AddRHProof.length == _newValidatorSet.length,
            "proof or validator set size is invalid"
        );
        uint256 len = _newValidatorSet.length;
        uint256 cnt = 0;
        uint256 totalVP = 0;
        uint256 totalValidVP = 0;
        address validator;
        // uint[] memory input;
        uint256 i;
        // uint256 j;
        for (i = 0; i < len; i++) {
            totalVP += _newValidatorSet[i].votingPower;

            if (
                keccak256(abi.encodePacked(_AddRHProof[i].optionName)) ==
                keccak256(abi.encodePacked(""))
            ) {
                break;
            }
            // for(j = 0; j < 32; j++) {
            //     input[i+j] = _proofs[i].pubKeys[j];
            // }
            // check signature in AddRHculateProof with messp[i][111];
            if (
                verifyAddRHuculateAddRHProof(_AddRHProof[i]) &&
                verifyCalculatePointMulProof(_verifyPMul1Proof[i])
            ) {
                // check Pubkey with pubkey in validator set
                // validator = address(uint160(_AddRHProof[i].input[0:32]));
                if (checkOldValidator(validator)) {
                    cnt++;
                }
                totalValidVP += _newValidatorSet[i].votingPower;
            }
        }

        if (cnt <= (validatorSet.length * 2) / 3) {
            return false;
        }

        if (totalValidVP <= (totalVP * 2) / 3) {
            return false;
        }
        return true;
    }

    function checkOldValidator(address pubkey) public view returns (bool) {
        uint256 len = validatorSet.length;
        for (uint i = 0; i < len; i++) {
            if (validatorSet[i].validatorAddress == pubkey) {
                return true;
            }
        }
        return false;
    }

    function verifyAddRHuculateAddRHProof(
        IVerifier.AddRHProof memory _AddRHProof
    ) public returns (bool) {
        string memory optionName = _AddRHProof.optionName;
        uint[2] memory a = _AddRHProof.pi_a;
        uint[2][2] memory b = _AddRHProof.pi_b;
        uint[2] memory c = _AddRHProof.pi_c;
        uint8[12] memory addRH = _AddRHProof.addRH;
        uint8[32] memory pubKeys = _AddRHProof.pubKeys;
        uint8[32] memory R8 = _AddRHProof.R8;
        uint8[] memory message = _AddRHProof.message;
        uint[] memory input;
        uint256 lenMsg = message.length;
        uint256 i;
        for (i = 0; i < 12; i++) {
            input[i] = addRH[i];
        }

        for (i = 0; i < 32; i++) {
            input[i + 12] = pubKeys[i];
        }

        for (i = 0; i < 32; i++) {
            input[i + 44] = R8[i];
        }

        for (i = 0; i < lenMsg; i++) {
            input[i + 76] = message[i];
        }
        // input.push();
        // IVerify().verifyProof(a, b, c, input);
        return _verifyProof(optionName, a, b, c, input);
    }

    function verifyCalculatePointMulProof(
        IVerifier.PMul1Proof memory _PMul1Proof
    ) public returns (bool) {
        string memory optionName = _PMul1Proof.optionName;
        uint[2] memory a = _PMul1Proof.pi_a;
        uint[2][2] memory b = _PMul1Proof.pi_b;
        uint[2] memory c = _PMul1Proof.pi_c;
        uint8[32] memory S = _PMul1Proof.S;
        uint[] memory input;
        for (uint256 i = 0; i < 32; i++) {
            input[i] = S[i];
        }
        // IVerify().verifyProof(a, b, c, input);
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

    function getCurrentBlockHeight() public view returns (uint256) {
        return currentHeight;
    }
}
