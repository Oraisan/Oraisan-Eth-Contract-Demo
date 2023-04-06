// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./IVerifier.sol";

interface ICosmosValidators is IVerifier {
    struct Validator {
        address validatorAddress;
        uint256 votingPower;
    }

    function getCurrentBlockHeight() external returns (uint256);

    function updateValidatorSet(
        uint256 _height,
        Validator[] memory _validatorSet
    ) external;

    function updateValidatorSetByProof() external;

    function verifyNewHeader(
        Validator[] memory _validatorSet,
        IVerifier.AddRHProof[] memory _AddRHProof,
        IVerifier.PMul1Proof[] memory _PMul1Proof
    ) external returns (bool);

    function calculateValidatorHash(
        Validator[] memory _validatorSet
    ) external returns (bytes memory);

    function checkOldValidator(address pubkey) external view returns (bool);

    function verifyEncodeMessageProof(
        IVerifier.EncodeMessageProof memory _encodeMessageProof
    ) external returns (bool);

    function verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) external view returns (bool);
}
