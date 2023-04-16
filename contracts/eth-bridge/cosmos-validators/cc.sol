pragma solidity 0.8.4;
contract CC {
    struct Validator {
        bytes validatorPubKey;
        uint256 votingPower;
    }

struct Header {
    uint256 height;
    bytes blockHash;
    uint256 blockTime;
    bytes dataHash;
    bytes validatorHash;
}

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

struct CCC {

    uint[2] pi_a;
    uint[2][2] pi_b;
    uint[2] pi_c;
 
}

function cc (CCC memory _cc) public view returns (uint256) {
    return 1;
}

function blockValidator(Validator[] memory _validator) public view returns (uint256) {
   return 1;
}


function blockHeader(Header memory _Header) public view returns (uint256) {
    return 1;
 }

 function blockSibling( bytes[] memory _siblingsDataAndValPath) public view returns (uint256) {
    return 1;
 }

 function blockProofs( SignatureValidatorProof[] memory _signatureValidatorProof) public view returns (uint256) {
    return 1;
 }

 function ac(
    Header memory _newBlockHeader,
    bytes[] memory _siblingsDataAndValPath,
  Validator[] memory _validatorSet,
    SignatureValidatorProof[] memory _signatureValidatorProof
 ) public view returns (uint256) {
    return 1;
 }
}