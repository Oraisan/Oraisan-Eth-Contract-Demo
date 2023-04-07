// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../../interface/IVerifier.sol";
import {IAVL_Tree} from "../../interface/IAVL_Tree.sol";
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
        bytes validatorAddress;
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
        Validator[] memory _validatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _PMul1Proof
    ) public returns (bool) {
        // require(
        //     verifyValidatorHash(_validatorHash, _validatorSet),
        //     "invalid validator hash"
        // );
        require(
            verifySignaturesHeader(_validatorSet, _AddRHProof, _PMul1Proof),
            "invalid validator set"
        );
        return true;
    }

    function calculateValidatorHash(
        Validator[] memory _validatorSet
    ) public returns (bytes memory) {
        uint256 len = _validatorSet.length;
        bytes[] memory validatorLeaf = new bytes[](len);
        bytes memory validatorEncode;
        for (uint256 i = 0; i < len; i++) {
            validatorEncode = encodeValidator(_validatorSet[i]);
            validatorLeaf[i] = IAVL_Tree(resolve("IAVL_Tree")).hashLeaf(
                validatorEncode
            );
        }

        return
            IAVL_Tree(resolve("IAVL_Tree")).calculateRootByLeafs(validatorLeaf);
    }

    function encodeValidator(
        Validator memory _validator
    ) public view returns (bytes memory) {
        return bytes("1");
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

    function verifySignaturesHeader(
        Validator[] memory _newValidatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _PMul1Proof
    ) public view returns (bool) {
        require(
            _AddRHProof.length == _newValidatorSet.length,
            "proof or validator set size is invalid"
        );
        uint256 len = _newValidatorSet.length;
        uint256 cnt = 0;
        uint256 totalVP = 0;
        uint256 totalValidVP = 0;
        bytes memory validator;
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
                verifyAddRHProof(_AddRHProof[i]) &&
                verifyPMul1Proof(_PMul1Proof[i])
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

    function checkOldValidator(bytes memory pubkey) public view returns (bool) {
        uint256 len = validatorSet.length;
        for (uint i = 0; i < len; i++) {
            if (
                keccak256(validatorSet[i].validatorAddress) == keccak256(pubkey)
            ) {
                return true;
            }
        }
        return false;
    }

    function verifyAddRHProof(
        IVerifier.AddRHProof memory _AddRHProof
    ) public view returns (bool) {
        string memory optionName = _AddRHProof.optionName;
        uint[2] memory a = _AddRHProof.pi_a;
        uint[2][2] memory b = _AddRHProof.pi_b;
        uint[2] memory c = _AddRHProof.pi_c;
        uint256[12] memory addRH = _AddRHProof.addRH;
        uint8[32] memory pubKeys = _AddRHProof.pubKeys;
        uint8[32] memory R8 = _AddRHProof.R8;
        uint8[] memory message = _AddRHProof.message;
        uint256 lenMsg = message.length;
        uint256[] memory input = new uint256[](76 + lenMsg);
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

    function verifyPMul1Proof(
        IVerifier.PMul1Proof memory _PMul1Proof
    ) public view returns (bool) {
        string memory optionName = _PMul1Proof.optionName;
        uint[2] memory a = _PMul1Proof.pi_a;
        uint[2][2] memory b = _PMul1Proof.pi_b;
        uint[2] memory c = _PMul1Proof.pi_c;
        uint8[32] memory S = _PMul1Proof.S;
        uint256[] memory input = new uint256[](32);
        for (uint256 i = 0; i < 32; i++) {
            input[i] = S[i];
        }
        // IVerify().verifyProof(a, b, c, input);
        return _verifyProof(optionName, a, b, c, input);
    }

    function verifyEncodeMessageProof(
        IVerifier.EncodeMessageProof memory _encodeMessageProof
    ) public view returns (bool) {
        string memory optionName = _encodeMessageProof.optionName;
        uint[2] memory a = _encodeMessageProof.pi_a;
        uint[2][2] memory b = _encodeMessageProof.pi_b;
        uint[2] memory c = _encodeMessageProof.pi_c;
        uint256 height = _encodeMessageProof.height;
        uint8[32] memory blockHash = _encodeMessageProof.blockHash;
        uint256 lenMess = _encodeMessageProof.mess.length;
        uint256 lenMsg;
        uint256 i;
        uint256 j;
        uint256 cnt;
        uint256[] memory input = new uint[](33 + lenMess * (1 + lenMsg));

        for (i = 0; i < lenMess; i++) {
            input[i] = _encodeMessageProof.mess[i].fnc;
        }

        input[i + 1] = height;
        cnt = lenMess + 1;

        for (i = 0; i < 32; i++) {
            input[i + cnt] = blockHash[i];
        }

        cnt += 32;
        for (i = 0; i < lenMess; i++) {
            lenMsg = _encodeMessageProof.mess[i].message.length;
            for (j = 0; j < lenMsg; i++) {
                input[j + cnt] = _encodeMessageProof.mess[i].message[j];
            }
            cnt += lenMsg;
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

    function getCurrentBlockHeight() public view returns (uint256) {
        return currentHeight;
    }
}
