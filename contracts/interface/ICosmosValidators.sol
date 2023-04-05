// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosValidators is IVerifier {
    struct Validator {
        address validatorAddress;
        uint256 votingPower;
    }

    function getCurrentBlockHeight() external returns (uint256);

    function updateValidatorSet(Validator[] memory _validatorSet) external;

    function updateValidatorSetByProof() external;

    function verifyNewHeader(
        bytes memory _validatorHash,
        Validator[] memory _validatorSet,
        IVerifier.AddRHProof[] memory _AddRHculateProof,
        IVerifier.PMul1Proof[] memory _verifyPMul1Proof,
        uint8[40][111] memory _validatorSignature
    ) external returns (bool);

    function verifyValidatorHash(
        uint256 validators_hash,
        Validator[] memory _validatorSet
    ) external returns (bool);

    function checkOldValidator(address pubkey) external view returns (bool);

    function verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) external view returns (bool);
}
