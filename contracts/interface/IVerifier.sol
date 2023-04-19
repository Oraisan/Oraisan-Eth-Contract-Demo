// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IVerifier {

    struct ValidatorHashProof {
        // string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint256 totalVPsigned;
        uint256 totalVP;
        uint256[] signed;
        uint8[] validatorPubKey;
    }

    // Ex optionName = "VERIFIER_DATA_AND_VAL"
    struct DataAndValsHashProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
    }
    // Ex with msg = 111 optionName = "VERIFIER_VALIDATOR_SIGNATURE_111"
    // with msg = 110 optionName = "VERIFIER_VALIDATOR_SIGNATURE_110"
    struct SignatureValidatorProof {
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint256[] memory input
    ) external view returns (bool r);
}
