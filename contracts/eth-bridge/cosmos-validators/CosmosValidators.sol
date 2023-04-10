// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IAVL_Tree} from "../../interface/IAVL_Tree.sol";
import {IVerifier} from "../../interface/IVerifier.sol";
import {IProcessString} from "../../interface/IProcessString.sol";
import {ICosmosBlockHeader} from "../../interface/ICosmosBlockHeader.sol";
import "../../libs/Lib_AddressResolver.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CosmosValidators is
    Lib_AddressResolver,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    struct Validator {
        bytes validatorPubKey;
        uint256 votingPower;
    }

    // struct ValidatorProof {
    //     uint256 leaf;
    //     uint256[] siblings;
    // }
    uint256 private numValidator;
    uint256 private currentHeight;
    Validator[] private validatorSet;
    mapping(uint256 => Validator[]) private validatorSetAtHeight;

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
        Validator[] memory _validatorSet
    ) public initializer {
        require(currentHeight == 0, "COsmosValidator is initialize");
        require(
            _numValidator == _validatorSet.length,
            "invalid numberValidator"
        );
        currentHeight = _currentHeight;
        numValidator = _numValidator;
        for (uint256 i = 0; i < _numValidator; i++) {
            validatorSet.push(_validatorSet[i]);
        }

        validatorSetAtHeight[_currentHeight] = validatorSet;

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
    function updateValidatorSet(
        uint256 _height,
        Validator[] memory _validatorSet
    ) external {
        require(msg.sender == resolve("OraisanGate"), "invalid sender");
        require(
            validatorSetAtHeight[_height].length == 0,
            "validator set was updated at height"
        );
        currentHeight = _height;
        uint256 len = _validatorSet.length;
        // validatorSet = new Validator[](len);
        delete validatorSet;

        for (uint256 i = 0; i < len; i++) {
            validatorSet.push(validatorSet[i]);
        }
        validatorSetAtHeight[_height] = validatorSet;
        numValidator = len;
    }

    // bridge validator
    function updateValidatorSetByProof() external {}

    function verifyNewHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        Validator[] memory _validatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) public returns (bool) {
        require(
            verifyValidatorHash(_newBlockHeader.validatorHash, _validatorSet),
            "invalid validator hash"
        );
        require(
            verifySignaturesHeader(
                _newBlockHeader.height,
                _newBlockHeader.blockHash,
                _newBlockHeader.blockTime,
                _validatorSet,
                _signatureValidatorProof
            ),
            "invalid validator set"
        );
        return true;
    }

    /*  ╔══════════════════════════════╗
        ║        VALIDATORS HASH       ║
        ╚══════════════════════════════╝       */

    function verifyValidatorHash(
        bytes memory _validatorHash,
        Validator[] memory _validatorSet
    ) public returns (bool) {
        bytes memory rootValidator = calculateValidatorHash(_validatorSet);
        return keccak256(_validatorHash) == keccak256(rootValidator);
    }

    function calculateValidatorHash(
        Validator[] memory _validatorSet
    ) public returns (bytes memory) {
        bytes[] memory validatorEncode = encodeValidatorSet(_validatorSet);

        return
            IAVL_Tree(resolve("IAVL_Tree")).calculateRootByLeafs(
                validatorEncode
            );
    }

    function encodeValidator(
        Validator memory _validator
    ) public view returns (bytes memory) {
        bytes1 prefixVP = 0x16;
        bytes1 prefixPubkey = 0x10;
        bytes1 prefixValidator = 0x10;
        bytes1 lenPubkey = 0x20;
        bytes1 lenEncodePubkey = 0x22;
        bytes memory encodeVP = IProcessString(resolve("ProcessString")).encodeSovInt(_validator.votingPower); 

        return abi.encodePacked(prefixValidator, lenEncodePubkey, prefixPubkey, lenPubkey, _validator.validatorPubKey, prefixVP, encodeVP);
    }

    function encodeValidatorSet(
        Validator[] memory _validatorSet
    ) public view returns (bytes[] memory) {
        uint256 len = _validatorSet.length;

        bytes[] memory a = new bytes[](len);

        for (uint256 i = 0; i < len; i++) {
            a[i] = encodeValidator(_validatorSet[i]);
        }
        return a;
    }

    /*  ╔══════════════════════════════╗
        ║     SIGNATURES FUNCTIONS     ║
        ╚══════════════════════════════╝       */

    function verifySignaturesHeader(
        uint256 _height,
        bytes memory _blockHash,
        uint256 _blockTime,
        Validator[] memory _newValidatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) public returns (bool) {
        uint256 lenValidator = _newValidatorSet.length;
        uint256 lenSignature = _signatureValidatorProof.length;
        uint256 i;

        require(
            lenSignature <= lenValidator,
            "invalid the number of validator"
        );

        uint8[32] memory _blockHashArray = IProcessString(
            resolve("ProcessString")
        ).convertBytesToUint8Array32(_blockHash);

        bytes memory validatorPubkeys;
        uint256 totalValidVP = 0;
        uint256 cnt = 0;
        uint256 oldIndex;
        uint256 newIndex;

        for (i = 0; i < lenSignature; i++) {
            validatorPubkeys = IProcessString(resolve("ProcessString"))
                .convertUint8Array32ToBytes(
                    _signatureValidatorProof[i].pubKeys
                );
            newIndex = _signatureValidatorProof[i].newIndex;

            if (
                keccak256(validatorPubkeys) !=
                keccak256(_newValidatorSet[newIndex].validatorPubKey)
            ) {
                continue;
            }

            if (
                verifyProofSignature(
                    _height,
                    _blockHashArray,
                    _blockTime,
                    _signatureValidatorProof[i]
                )
            ) {
                oldIndex = _signatureValidatorProof[i].oldIndex;
                if (_signatureValidatorProof[i].oldIndex != 0) {
                    if (
                        keccak256(validatorPubkeys) !=
                        keccak256(validatorSet[oldIndex].validatorPubKey)
                    ) {
                        continue;
                    }

                    cnt++;
                }

                totalValidVP += _newValidatorSet[newIndex].votingPower;
            }
        }

        uint256 totalVP = 0;
        for (i = 0; i < lenValidator; i++) {
            totalVP += _newValidatorSet[i].votingPower;
        }

        if (cnt < (validatorSet.length * 2) / 3) {
            return false;
        }

        if (totalValidVP < (totalVP * 2) / 3) {
            return false;
        }
        return true;
    }

    function verifyProofSignature(
        uint256 _height,
        uint8[32] memory _blockHash,
        uint256 _blockTime,
        IVerifier.SignatureValidatorProof memory _signatureValidatorProof
    ) public view returns (bool) {
        string memory optionName = _signatureValidatorProof.optionName;

        uint[2] memory a = _signatureValidatorProof.pi_a;
        uint[2][2] memory b = _signatureValidatorProof.pi_b;
        uint[2] memory c = _signatureValidatorProof.pi_c;

        uint8[32] memory pubKeys = _signatureValidatorProof.pubKeys;
        uint8[32] memory R8 = _signatureValidatorProof.R8;
        uint8[32] memory S = _signatureValidatorProof.S;

        uint256[] memory input = new uint256[](130);
        uint256 i;

        input[0] = _height;

        for (i = 0; i < 32; i++) {
            input[i + 1] = _blockHash[i];
        }

        input[i + 33] = _blockTime;

        for (i = 0; i < 32; i++) {
            input[i + 34] = pubKeys[i];
            input[i + 66] = R8[i];
            input[i + 98] = S[i];
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

    function getValidatorSetAtHeight(
        uint256 _height
    ) public view returns (Validator[] memory) {
        return validatorSetAtHeight[_height];
    }

    function getValidatorAtHeight(
        uint256 _height,
        uint256 _index
    ) public view returns (Validator memory) {
        require(_index < validatorSetAtHeight[_height].length, "invalid index");
        return validatorSetAtHeight[_height][_index];
    }
}
