// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {IVerifier} from "./IVerifier.sol";
import {ICosmosBlockHeader} from "./ICosmosBlockHeader.sol";

interface ICosmosValidators {
    
    function updateValidatorSet(
        uint256 height,
        uint8[] memory validatorPubKeyL,
        uint8[] memory validatorPubKeyR
    ) external;

    function updateValidatorSetByProof() external;

    function verifyNewHeader(
        ICosmosBlockHeader.Header memory newBlockHeader,
        IVerifier.ValidatorHashProof[2] memory validatorHashProof,
        IVerifier.SignatureValidatorProof[] memory signatureValidatorProof
    ) external returns (bool);

    function verifyValidatorHash(
        bytes memory validatorHash,
        IVerifier.ValidatorHashProof[2] memory validatorHashProof
    ) external returns (bool);

    function verifySignaturesHeader(
        uint256 height,
        bytes memory blockHash,
        uint256 blockTime,
        IVerifier.ValidatorHashProof[2] memory validatorHashProof,
        IVerifier.SignatureValidatorProof[] memory signatureValidatorProof
    ) external returns (bool);

    function verifyProofSignature(
        uint256 height,
        uint8[32] memory blockHash,
        uint256 blockTime,
        IVerifier.SignatureValidatorProof memory signatureValidatorProof
    ) external view returns (bool);

    function getCurrentBlockHeight() external view returns (uint256);

    function getValidatorSetAtHeight(
        uint256 height
    ) external view returns (bytes[] memory);

    function getValidatorAtHeight(
        uint256 height,
        uint256 index
    ) external view returns (bytes memory);
}
