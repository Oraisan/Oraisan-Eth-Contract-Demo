// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {IVerifier} from "./IVerifier.sol";
import {ICosmosBlockHeader} from "./ICosmosBlockHeader.sol";

interface ICosmosValidators {
    function updateValidatorSet(
        uint256 _height,
        address[] memory _validatorLeft,
        address[] memory _validatorRight
    ) external;

    function updateValidatorSetByProof() external;

    function verifyNewHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashLeftProof memory _validatorHashLeftProof,
        IVerifier.ValidatorHashRightProof memory _validatorHashRightProof,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external returns (bool);

    function verifyValidatorHashRight(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashRightProof memory _validatorHashRightProof
    ) external returns (bool);

    function verifyValidatorHashLeft(
        address _validatorHash,
        IVerifier.ValidatorHashLeftProof memory _validatorHashLeftProof
    ) external returns (bool);

    function verifyProofSignature(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        address _validatorAddress,
        IVerifier.SignatureValidatorProof memory _signatureValidatorProof
    )  external returns (bool);

    function getCurrentBlockHeight() external view returns (uint256);

    function getValidatorSetAtHeight(
        uint256 height
    ) external view returns (bytes[] memory);

    function getValidatorAtHeight(
        uint256 height,
        uint256 index
    ) external view returns (bytes memory);

    function getValidatorHeight(
        bytes memory _pubkey
    ) external view returns (uint256);
}
