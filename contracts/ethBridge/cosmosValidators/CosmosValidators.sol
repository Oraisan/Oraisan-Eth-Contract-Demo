// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../../interface/IVerifier.sol";
import {ICosmosBlockHeader} from "../../interface/ICosmosBlockHeader.sol";
import "../../libs/Lib_AddressResolver.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CosmosValidators is
    Lib_AddressResolver,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    address validatorPubKey;
    // uint256 votingPower;

    uint256 internal numValidator;
    uint256 internal currentHeight;
    address[] internal validatorSet;

    mapping(uint256 => address[]) internal validatorSetAtHeight;
    mapping(address => uint256) internal validatorHeight;

    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize(
        address _libAddressManager,
        uint256 _currentHeight,
        address[] memory _validatorSet
    ) public initializer {
        require(currentHeight == 0, "COSMOS_VALIDATORS is initialize");

        numValidator = _validatorSet.length;
        currentHeight = _currentHeight;

        uint256 i = 0;

        for (i = 0; i < numValidator; i++) {
            validatorSet.push(_validatorSet[i]);
            validatorHeight[_validatorSet[i]] = _currentHeight;
        }

        validatorSetAtHeight[_currentHeight] = validatorSet;

        __Lib_AddressResolver_init(_libAddressManager);
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Pausable_init_unchained();
        __ReentrancyGuard_init_unchained();
    }

    /**
     * Pause relaying.
     */
    function pause() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }

    /*  ╔══════════════════════════════╗
        ║        ADMIN FUNCTIONS       ║
        ╚══════════════════════════════╝       */
    function updateValidatorSet(
        uint256 _height,
        address[] memory _validatorLeft,
        address[] memory _validatorRight
    ) external {
        require(msg.sender == resolve("ORAISAN_GATE") || msg.sender == owner(), "invalid sender");
        require(
            validatorSetAtHeight[_height].length == 0,
            "validator set was updated at height"
        );

        currentHeight = _height;

        uint256 lenL = _validatorLeft.length;
        uint256 lenR = _validatorRight.length;
        // validatorSet = new bytes[](len);
        delete validatorSet;

        uint256 i;

        for (i = 0; i < lenL; i++) {
            validatorSet.push(
                _validatorLeft[i]
            );
            validatorHeight[_validatorLeft[i]] = _height;
        }

        for (i = 0; i < lenR; i++) {
            validatorSet.push(
                _validatorRight[i]
            );
            validatorHeight[_validatorRight[i]] = _height;
        }

        validatorSetAtHeight[_height] = validatorSet;
        numValidator = lenL + lenR;
    }

    /*  ╔══════════════════════════════╗
        ║        VERIFY FUNCTIONS      ║
        ╚══════════════════════════════╝       */
    function verifyNewHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashLeftProof memory _validatorHashLeftProof,
        IVerifier.ValidatorHashRightProof memory _validatorHashRightProof,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) public view returns (bool) {
        uint256 i;

        require(
            3 *
                (_validatorHashLeftProof.totalVPsigned +
                    _validatorHashRightProof.totalVPsigned) >
                2 *
                    (_validatorHashLeftProof.totalVP +
                        _validatorHashRightProof.totalVP),
            "Invalid total voting power"
        );

        require(
            verifyValidatorHashRight(_newBlockHeader, _validatorHashRightProof),
            "invalid validator hash left"
        );

        require(
            verifyValidatorHashLeft(
                _newBlockHeader.validatorHash,
                _validatorHashLeftProof
            ),
            "invalid validator hash Right"
        );

        uint256 lenSignature = _signatureValidatorProof.length;

        uint256 lenValLeft = _validatorHashLeftProof.validatorAddress.length;
        uint256 lenValRight = _validatorHashRightProof.validatorAddress.length;

        uint256 leftSigned = _validatorHashLeftProof.signed;
        uint256 rightSigned = _validatorHashRightProof.signed;

        require(lenSignature >= countBitOne(leftSigned, lenValLeft) + countBitOne(rightSigned, lenValRight), "invalid the number of signatures");
        
        address validatorAddress;

        uint256 idx;
        uint256 cnt = 0;

        for (i = 0; i < lenSignature; i++) {
            idx = _signatureValidatorProof[i].index < lenValLeft
                ? _signatureValidatorProof[i].index
                : _signatureValidatorProof[i].index - lenValLeft;
            validatorAddress = idx < lenValLeft
                ? _validatorHashLeftProof.validatorAddress[idx]
                : _validatorHashRightProof.validatorAddress[idx];
            if ((leftSigned >> idx) & 1 == 1) {
                require(
                    verifyProofSignature(
                        _newBlockHeader,
                        validatorAddress,
                        _signatureValidatorProof[i]
                    ),
                    "invalid validator set"
                );
            }

            if (getValidatorHeight(validatorAddress) == currentHeight) {
                cnt++;
            }
        }
        //verify validator

        require(3 * cnt > 2 * numValidator, "invalid number of validators");
        return true;
    }

    function countBitOne(uint256 x, uint256 len) public pure returns(uint256) {
        uint256 cnt = 0;
        for(uint256 i = 0; i < len; i++) {
            cnt = cnt + ((x >> i) & 1);
        }
        return cnt;
    }

    /*  ╔══════════════════════════════╗
        ║        VALIDATORS HASH       ║
        ╚══════════════════════════════╝       */

    function verifyValidatorHashRight(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashRightProof memory _validatorHashRightProof
    ) public view returns (bool) {
        string memory optionName = _validatorHashRightProof.optionName;
        uint[2] memory a = _validatorHashRightProof.pi_a;
        uint[2][2] memory b = _validatorHashRightProof.pi_b;
        uint[2] memory c = _validatorHashRightProof.pi_c;

        uint256 totalVPsigned = _validatorHashRightProof.totalVPsigned;
        uint256 totalVP = _validatorHashRightProof.totalVP;

        uint256 len = _validatorHashRightProof.validatorAddress.length;

        uint256[] memory input = new uint256[](6 + len);
        uint256 i;

        input[0] = totalVPsigned;
        input[1] = totalVP;

        for (i = 0; i < len; i++) {
            input[i + 2] = uint256(
                uint160(_validatorHashRightProof.validatorAddress[i])
            );
        }

        input[len + 2] = uint256(uint160(_newBlockHeader.validatorHash));
        input[len + 3] = uint256(uint160(_newBlockHeader.dataHash));
        input[len + 4] = uint256(uint160(_newBlockHeader.blockHash));
        input[len + 5] = _validatorHashRightProof.signed;

        return _verifyProof(optionName, a, b, c, input);
    }

    function verifyValidatorHashLeft(
        uint160 _validatorHash,
        IVerifier.ValidatorHashLeftProof memory _validatorHashLeftProof
    ) public view returns (bool) {
        string memory optionName = _validatorHashLeftProof.optionName;
        uint[2] memory a = _validatorHashLeftProof.pi_a;
        uint[2][2] memory b = _validatorHashLeftProof.pi_b;
        uint[2] memory c = _validatorHashLeftProof.pi_c;

        uint256 totalVPsigned = _validatorHashLeftProof.totalVPsigned;
        uint256 totalVP = _validatorHashLeftProof.totalVP;

        uint256 len = _validatorHashLeftProof.validatorAddress.length;

        uint256[] memory input = new uint256[](4 + len);
        uint256 i;

        input[0] = totalVPsigned;
        input[1] = totalVP;

        for (i = 0; i < len; i++) {
            input[i + 2] = uint256(
                uint160(_validatorHashLeftProof.validatorAddress[i])
            );
        }

        input[len + 2] = uint256(uint160(_validatorHash));

        input[len + 3] = _validatorHashLeftProof.signed;

        return _verifyProof(optionName, a, b, c, input);
    }

    /*  ╔══════════════════════════════╗
        ║     SIGNATURES FUNCTIONS     ║
        ╚══════════════════════════════╝       */

    function verifyProofSignature(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        address _validatorAddress,
        IVerifier.SignatureValidatorProof memory _signatureValidatorProof
    ) public view returns (bool) {
        string memory optionName = _signatureValidatorProof.optionName;        
        uint[2] memory a = _signatureValidatorProof.pi_a;
        uint[2][2] memory b = _signatureValidatorProof.pi_b;
        uint[2] memory c = _signatureValidatorProof.pi_c;
        uint256[] memory input = new uint256[](4);

        input[0] = uint256(uint160(_validatorAddress));
        input[1] = uint256(uint160(_newBlockHeader.blockHash));
        input[2] = _newBlockHeader.height;
        input[3] = _newBlockHeader.blockTime;

        return _verifyProof(optionName, a, b, c, input);
    }

    function _verifyProof(
        string memory _optionName, //Ex: VERIFIER_AGE
        uint[2] memory pi_a,
        uint[2][2] memory pi_b,
        uint[2] memory pi_c,
        uint[] memory input
    ) internal view returns (bool) {
        return
            IVerifier(resolve(_optionName)).verifyProof(
                pi_a,
                pi_b,
                pi_c,
                input
            );
    }

    /*  ╔══════════════════════════════╗
        ║         GET FUNCTIONS        ║
        ╚══════════════════════════════╝       */

    function getCurrentBlockHeight() public view returns (uint256) {
        return currentHeight;
    }

    function getValidatorSetAtHeight(
        uint256 _height
    ) public view returns (address[] memory) {
        return validatorSetAtHeight[_height];
    }

    function getValidatorAtHeight(
        uint256 _height,
        uint256 _index
    ) public view returns (address) {
        require(_index < validatorSetAtHeight[_height].length, "invalid index");
        return validatorSetAtHeight[_height][_index];
    }

    function getValidatorHeight(address _pubkey) public view returns (uint256) {
        return validatorHeight[_pubkey];
    }
}
