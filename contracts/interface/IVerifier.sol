// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IVerifier {

    struct ClaimTransactionProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        address eth_bridge_address;
        address eth_receiver;
        uint256 amount;
        address eth_token_address;
        uint256 key;
        uint256 depositRoot;
    }

    struct DepositRootProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint160 cosmosSender;
        uint160 cosmosBridge;
        uint256 depositRoot;
        uint160 dataHash;
    }

    struct ValidatorHashLeftProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint256 totalVPsigned;
        uint256 totalVP;
        address[] validatorAddress;
        //address validatorHashAddress;
        //address dataHashAddress;
        //address blockHashAddress;
        uint256 signed;
    }

    struct ValidatorHashRightProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        uint256 totalVPsigned;
        uint256 totalVP;
        address[] validatorAddress;
        //address validatorHashAddress;
        uint256 signed;
    }

    // Ex with msg = 111 optionName = "VERIFIER_VALIDATOR_SIGNATURE_111"
    // with msg = 110 optionName = "VERIFIER_VALIDATOR_SIGNATURE_110"
    struct SignatureValidatorProof {
        string optionName;
        uint[2] pi_a;
        uint[2][2] pi_b;
        uint[2] pi_c;
        //address validatorAddress
        //address blockHash
        //uint256 height
        //uint256 blockTime
        uint256 index;
    }

    /// @return r  bool true if proof is valid
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint256[] memory input
    ) external view returns (bool r);
}
