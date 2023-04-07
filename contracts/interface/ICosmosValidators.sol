// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {IVerifier} from "./IVerifier.sol";
import {ICosmosBlockHeader} from "./ICosmosBlockHeader.sol";

interface ICosmosValidators {
    struct Validator {
        address validatorAddress;
        uint256 votingPower;
    }

    function updateValidatorSet(
        uint256 _height,
        Validator[] memory _validatorSet
    ) external;

    function updateValidatorSetByProof() external;

    function verifyNewHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        Validator[] memory _validatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external returns (bool);

    function verifyValidatorHash(
        bytes memory _validatorHash,
        Validator[] memory _validatorSet
    ) external returns (bool);

    function calculateValidatorHash(
        Validator[] memory _validatorSet
    ) external returns (bytes memory);

    function encodeValidator(
        Validator memory _validator
    ) external view returns (bytes memory);

    function encodeValidatorSet(
        Validator[] memory _validatorSet
    ) external view returns (bytes[] memory);

    function verifySignaturesHeader(
        uint256 _height,
        bytes memory _blockHash,
        uint256 _blockTime,
        Validator[] memory _newValidatorSet,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external returns (bool);

    function verifyProofSignature(
        uint256 _height,
        uint8[32] memory _blockHash,
        uint256 _blockTime,
        IVerifier.SignatureValidatorProof memory _signatureValidatorProof
    ) external view returns (bool);

    function getCurrentBlockHeight() external view returns (uint256);

    function getValidatorSetAtHeight(
        uint256 _height
    ) external view returns (Validator[] memory);

    function getValidatorAtHeight(
        uint256 _height,
        uint256 _index
    ) external view returns (Validator memory);
}
