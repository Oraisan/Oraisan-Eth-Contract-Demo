// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IVerifier {
    // optionName = ten struc
    // Ex optionName = "AddRHculateAddRH"
    struct AddRHProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        bytes[12] addRH;
        uint8[32] pubKeys;
        uint8[32] R8;
        uint8[111] message;
    }
    // Ex optionName = "PMul1"
    struct PMul1Proof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint8[32] S;
    }

    struct Mess {
        uint256 fnc;
        uint8[] mess;
    }
    // Ex optionName = "EncodeMessage"
    struct EncodeMessageProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint8[32] fnc;
        uint256 height;
        uint8[32] blockHash;
        Mess[] message;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[] memory input
    ) external view returns (bool r);
}
