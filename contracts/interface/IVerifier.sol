// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IVerifier {
    struct DataAndValsHashProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
    }
    // optionName = ten struct
    // Ex optionName = "CosmosValidatorsignature"
    struct SignatureValidatorProof {
        string optionName;
        uint8 oldIndex;
        uint8 newIndex;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint8[32] pubKeys;
        uint8[32] R8;
        uint8[32] S;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint256[] memory input
    ) external view returns (bool r);
}
