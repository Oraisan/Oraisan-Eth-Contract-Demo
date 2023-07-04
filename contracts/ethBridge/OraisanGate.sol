// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {IVerifier} from "../interface/IVerifier.sol";
import {ICosmosValidators} from "../interface/ICosmosValidators.sol";
import "../libs/Lib_AddressResolver.sol";

import {ICosmosBlockHeader} from "../interface/ICosmosBlockHeader.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract OraisanGate is
    Lib_AddressResolver,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/
    event BlockHeaderUpdated(
        uint256 blockHeight,
        bytes20 blockHash,
        address updater
    );
    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/
    uint256 status;

    function initialize(address _libAddressManager) public initializer {
        require(status == 0, "OraisanGate is deployed");
        status = 1;
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

    function updateblockHeader(
        ICosmosBlockHeader.Header memory _newBlockHeader,
        IVerifier.ValidatorHashLeftProof memory _validatorHashLeftProof,
        IVerifier.ValidatorHashRightProof memory _validatorHashRightProof,
        IVerifier.SignatureValidatorProof[] memory _signatureValidatorProof
    ) external whenNotPaused {
        require(
            ICosmosValidators(resolve("COSMOS_VALIDATORS")).verifyNewHeader(
                _newBlockHeader,
                _validatorHashLeftProof,
                _validatorHashRightProof,
                _signatureValidatorProof
            ),
            "invalid validator signature"
        );

        uint256 height = _newBlockHeader.height;

        ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSetLR(
            height,
            _validatorHashLeftProof.validatorAddress,
            _validatorHashRightProof.validatorAddress
        );

        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
            height,
            _newBlockHeader.blockHash
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateDataHash(
            _newBlockHeader.height,
            _newBlockHeader.dataHash
        );

        emit BlockHeaderUpdated(
            _newBlockHeader.height,
            _newBlockHeader.blockHash,
            msg.sender
        );
    }

    function updateblockHeaderTestnet(
        IVerifier.BlockHeaderTestnetProof memory _blockHeaderProof
    ) external whenNotPaused {
        string memory optionName = _blockHeaderProof.optionName;
        uint[2] memory pi_a = _blockHeaderProof.pi_a;
        uint[2][2] memory pi_b = _blockHeaderProof.pi_b;
        uint[2] memory pi_c = _blockHeaderProof.pi_c;
        uint256[] memory input = new uint[](5);

        input[0] = uint256(uint160(_blockHeaderProof.validatorAddress));
        input[1] = uint256(uint160(_blockHeaderProof.validatorHash));
        input[2] = uint256(uint160(_blockHeaderProof.dataHash));
        input[3] = uint256(uint160(_blockHeaderProof.blockHash));
        input[4] = _blockHeaderProof.height;

        require(
            IVerifier(resolve(optionName)).verifyProof(pi_a, pi_b, pi_c, input),
            "Invalid blockheader proof"
        );

        uint256 height = _blockHeaderProof.height;

        ICosmosValidators(resolve("COSMOS_VALIDATORS")).updateValidatorSetTestnet(
            height,
            _blockHeaderProof.validatorAddress
        );

        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateBlockHash(
            height,
            _blockHeaderProof.blockHash
        );
        ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER")).updateDataHash(
            height,
            _blockHeaderProof.dataHash
        );

        emit BlockHeaderUpdated(
            height,
            _blockHeaderProof.blockHash,
            msg.sender
        );
    }

    /*  ╔══════════════════════════════╗
      ║        USERS FUNCTIONS       ║
      ╚══════════════════════════════╝ */
}
