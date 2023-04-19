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
    bytes validatorPubKey;
    // uint256 votingPower;

    uint256 internal numValidator;
    uint256 internal currentHeight;
    bytes[] internal validatorSet;

    mapping(uint256 => bytes[]) internal validatorSetAtHeight;
    mapping(bytes => uint256) internal validatorHeight;

    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize(
        address _libAddressManager,
        uint256 _currentHeight,
        bytes[] memory _validatorSet
    ) public initializer {
        require(currentHeight == 0, "COSMOS_VALIDATORS is initialize");

        numValidator = _validatorSet.length;
        currentHeight = _currentHeight;

        uint256 i = 0;

        for (i = 0; i < numValidator; i++) {
            validatorSet.push(_validatorSet[i]);
            validatorHeight[_validatorSet[i]] = _currentHeight;
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
        uint8[] memory validatorPubKeyL,
        uint8[] memory validatorPubKeyR
    ) external {
        require(msg.sender == resolve("ORAISAN_GATE"), "invalid sender");
        require(
            validatorSetAtHeight[_height].length == 0,
            "validator set was updated at height"
        );

        currentHeight = _height;

        uint256 lenL = validatorPubKeyL.length;
        uint256 lenR = validatorPubKeyR.length;
        // validatorSet = new bytes[](len);
        delete validatorSet;

        uint256 i;
        uint256 k;

        uint8[32] memory pubkey;

        for (i = 0; i < lenL; i++) {
            for (k = 0; k < 32; k++) {
                pubkey[k] = validatorPubKeyL[i * 32 + k];
            }

            validatorSet.push(
                IProcessString(resolve("PROCESS_STRING")).convertUint8Array32ToBytes(pubkey)
            );
            validatorHeight[validatorSet[i]] = _height;
        }

        for (i = 0; i < lenR; i++) {
            for (k = 0; k < 32; k++) {
                pubkey[k] = validatorPubKeyR[i * 32 + k];
            }

            validatorSet.push(
                IProcessString(resolve("PROCESS_STRING")).convertUint8Array32ToBytes(pubkey)
            );
            validatorHeight[validatorSet[lenL + i]] = _height;
        }

        validatorSetAtHeight[_height] = validatorSet;
        numValidator = lenL + lenR;
    }

    // bridge validator
    function updateValidatorSetByProof() external {}

    /*  ╔══════════════════════════════╗
        ║        VERIFY FUNCTIONS      ║
        ╚══════════════════════════════╝       */
    function verifyNewHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashProof[2] memory _validatorHashProof,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) public returns (bool) {
        uint256 i;
        uint256 j;
        uint256 k;

        require(
            3 *
                (_validatorHashProof[0].totalVPsigned +
                    _validatorHashProof[1].totalVPsigned) >
                2 *
                    (_validatorHashProof[0].totalVP +
                        _validatorHashProof[1].totalVP),
            "Invalid total voting power"
        );

        uint8[32] memory validatorHash = IProcessString(resolve("PROCESS_STRING"))
            .convertBytesToUint8Array32(_newBlockHeader.validatorHash);

        uint256 lenSignature = _signatureValidatorProof.length;
        uint256 idxSignature;
        uint8[32] memory pubkey;

        uint256 cnt = 0;

        for (i = 0; i < 2; i++) {
            // verify blockHash
            string memory validatorHashVerifierName;
            if (i == 0) {
                validatorHashVerifierName = "VALIDATORS_LEFT";
            } else {
                validatorHashVerifierName = "VALIDATOR_RIGHT";
            }

            require(
                verifyValidatorHash(
                    validatorHashVerifierName,
                    validatorHash,
                    _validatorHashProof[i]
                ),
                "invalid validator hash"
            );

            //verify validator
            uint256 len = _validatorHashProof[i].signed.length;
            for (j = 0; j < len; j++) {
                for (k = 0; k < 32; k++) {
                    pubkey[k] = _validatorHashProof[i].validatorPubKey[
                        j * 32 + k
                    ];
                }

                idxSignature = _validatorHashProof[i].signed[j];
                if (idxSignature < lenSignature) {
                    require(
                        verifyProofSignature(
                            _newBlockHeader,
                            pubkey,
                            _signatureValidatorProof[idxSignature]
                        ),
                        "invalid validator set"
                    );
                }

                if (
                    getValidatorHeight(
                        IProcessString(resolve("PROCESS_STRING"))
                            .convertUint8Array32ToBytes(pubkey)
                    ) == currentHeight
                ) {
                    cnt++;
                }
            }
        }

        require(3 * cnt > 2 * numValidator, "invalid number of validators");
        return true;
    }

    /*  ╔══════════════════════════════╗
        ║        VALIDATORS HASH       ║
        ╚══════════════════════════════╝       */

    function verifyValidatorHash(
        string memory _optionName,
        uint8[32] memory _validatorHash,
        IVerifier.ValidatorHashProof memory _validatorHashProof
    ) public view returns (bool) {
        uint[2] memory a = _validatorHashProof.pi_a;
        uint[2][2] memory b = _validatorHashProof.pi_b;
        uint[2] memory c = _validatorHashProof.pi_c;

        uint256 totalVPsigned = _validatorHashProof.totalVPsigned;
        uint256 totalVP = _validatorHashProof.totalVP;

        uint256 len = _validatorHashProof.signed.length;

        require(
            len * 32 == _validatorHashProof.validatorPubKey.length,
            "invalid validatorHashProof"
        );

        uint256[] memory input = new uint256[](2 + len * 34);
        uint256 i;

        input[0] = totalVPsigned;
        input[1] = totalVP;

        for (i = 0; i < len; i++) {
            input[i + 2] = (_validatorHashProof.signed[i] < 100) ? 1 : 0;
        }

        for (i = 0; i < 32 * len; i++) {
            input[i + 2 + len] = _validatorHashProof.validatorPubKey[i];
        }

        for (i = 0; i < len; i++) {
            input[i + 2 + 33 * len] = _validatorHash[i];
        }

        return _verifyProof(_optionName, a, b, c, input);
    }

    /*  ╔══════════════════════════════╗
        ║     SIGNATURES FUNCTIONS     ║
        ╚══════════════════════════════╝       */

    function verifyProofSignature(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        uint8[32] memory _pubkey,
        IVerifier.SignatureValidatorProof memory _signatureValidatorProof
    ) public returns (bool) {
        uint[2] memory a = _signatureValidatorProof.pi_a;
        uint[2][2] memory b = _signatureValidatorProof.pi_b;
        uint[2] memory c = _signatureValidatorProof.pi_c;
        uint256[] memory input = new uint256[](66);

        uint256 i;

        uint8[32] memory blockHash = IProcessString(resolve("PROCESS_STRING"))
            .convertBytesToUint8Array32(_newBlockHeader.blockHash);

        input[0] = _newBlockHeader.height;

        for (i = 0; i < 32; i++) {
            input[i + 1] = blockHash[i];
        }

        input[33] = _newBlockHeader.blockTime;

        for (i = 0; i < 32; i++) {
            input[i + 34] = _pubkey[i];
        }

        return _verifyProof("VALIDATOR_SIGNATURE", a, b, c, input);
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
    ) public view returns (bytes[] memory) {
        return validatorSetAtHeight[_height];
    }

    function getValidatorAtHeight(
        uint256 _height,
        uint256 _index
    ) public view returns (bytes memory) {
        require(_index < validatorSetAtHeight[_height].length, "invalid index");
        return validatorSetAtHeight[_height][_index];
    }

    function getValidatorHeight(
        bytes memory pubkey
    ) public view returns (uint256) {
        return validatorHeight[pubkey];
    }
}
