// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./MerkleTreeWithHistory.sol";

import {IVerifier} from "../interface/IVerifier.sol";
import {ICosmosBlockHeader} from "../interface/ICosmosBlockHeader.sol";
import {IERC20Token} from "../interface/IERC20Token.sol";
import "../libs/Lib_AddressResolver.sol";

import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract OraisanBridge is
    Lib_AddressResolver,
    MerkleTreeWithHistory,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/
    event UpdateDepositRootCompleted(uint[] indexed inputs, uint256 timestamp);
    event ClaimTransactionCompleted(uint[] indexed inputs, uint256 timestamp);

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    // mapping(uint256 => address) public updaterAtHeight;
    mapping(uint160 => bool) public isSupportCosmosBridge;
    mapping(uint160 => address) public cosmosToEthTokenAddress;
    mapping(address => uint160) public ethToCosmosTokenAddress;
    mapping(uint256 => bool) public isClaimed;
    mapping(bytes32 => bool) public sentProof;

    function initialize(
        address _libAddressManager,
        uint32 _merkleTreeHeight
    ) public initializer {
        require(
            levels == 0 && address(libAddressManager) == address(0),
            "Bridge is already initialized"
        );

        __Lib_AddressResolver_init(_libAddressManager);
        __MerkleTreeWithHistory_init(_merkleTreeHeight);
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

    function registerCosmosBridge(
        uint160 _cosmosBridge,
        bool _isSupport
    ) external whenNotPaused onlyOwner {
        require(
            isSupportCosmosBridge[_cosmosBridge] != _isSupport,
            "cosmos bridge was supported!"
        );
        isSupportCosmosBridge[_cosmosBridge] = _isSupport;
    }

    function registerTokenPair(
        uint160 _cosmosTokenAddress,
        address _ethTokenAddress
    ) external whenNotPaused onlyOwner {
        require(
            cosmosToEthTokenAddress[_cosmosTokenAddress] == address(0) ||
                ethToCosmosTokenAddress[_ethTokenAddress] == 0,
            "token was registered!"
        );
        cosmosToEthTokenAddress[_cosmosTokenAddress] = _ethTokenAddress;
        ethToCosmosTokenAddress[_ethTokenAddress] = _cosmosTokenAddress;
    }

    function deleteTokenPair(uint160 _cosmosTokenAddress) external onlyOwner {
        address _ethToken = cosmosToEthTokenAddress[_cosmosTokenAddress];
        cosmosToEthTokenAddress[_cosmosTokenAddress] = address(0);
        ethToCosmosTokenAddress[_ethToken] = 0;
    }

    function updateRootDepositTree(
        IVerifier.DepositRootProof memory _depositRootProof
    ) external whenNotPaused returns (bool) {
        require(
            isSupportCosmosBridge[_depositRootProof.cosmosBridge],
            "Do not support this bridge"
        );

        require(
            _depositRootProof.dataHash ==
                ICosmosBlockHeader(resolve("COSMOS_BLOCK_HEADER"))
                    .getCurrentDataHash(),
            "Data hash is invalid!"
        );

        string memory optionName = _depositRootProof.optionName;
        uint[2] memory pi_a = _depositRootProof.pi_a;
        uint[2][2] memory pi_b = _depositRootProof.pi_b;
        uint[2] memory pi_c = _depositRootProof.pi_c;
        uint256[] memory input = new uint256[](4);

        input[0] = uint256(_depositRootProof.cosmosSender);
        input[1] = uint256(_depositRootProof.cosmosBridge);
        input[2] = _depositRootProof.depositRoot;
        input[3] = uint256(_depositRootProof.dataHash);

        require(
            IVerifier(resolve(optionName)).verifyProof(pi_a, pi_b, pi_c, input),
            "Invalid depositRoot proof"
        );

        bool isInsert = _insert(_depositRootProof.depositRoot);

        emit UpdateDepositRootCompleted(input, block.timestamp);
        return isInsert;
    }

    function claimTransaction(
        IVerifier.ClaimTransactionProof memory _claimTransactionProof
    ) external {
        require(
            ethToCosmosTokenAddress[_claimTransactionProof.eth_token_address] !=
                0,
            "Not support this token"
        );
        require(
            _claimTransactionProof.eth_bridge_address == address(this),
            "This bridge isn't support for clamming token"
        );
        require(
            isKnownDepostRoot(_claimTransactionProof.depositRoot),
            "Deposit root is invalid"
        );

        bytes memory messageProof = encodeProof(
            _claimTransactionProof.eth_bridge_address,
            _claimTransactionProof.eth_receiver,
            _claimTransactionProof.amount,
            _claimTransactionProof.eth_token_address,
            _claimTransactionProof.key
        );

        require(
            !sentProof[keccak256(messageProof)],
            "token was claimed with this proof"
        );

        sentProof[keccak256(messageProof)] = true;

        string memory optionName = _claimTransactionProof.optionName;
        uint[2] memory pi_a = _claimTransactionProof.pi_a;
        uint[2][2] memory pi_b = _claimTransactionProof.pi_b;
        uint[2] memory pi_c = _claimTransactionProof.pi_c;
        uint256[] memory input = new uint256[](6);

        input[0] = uint256(uint160(_claimTransactionProof.eth_bridge_address));
        input[1] = uint256(uint160(_claimTransactionProof.eth_receiver));
        input[2] = _claimTransactionProof.amount;
        input[3] = uint256(uint160(_claimTransactionProof.eth_token_address));
        input[4] = _claimTransactionProof.key;
        input[5] = _claimTransactionProof.depositRoot;

        require(
            IVerifier(resolve(optionName)).verifyProof(pi_a, pi_b, pi_c, input),
            "Invalid depositRoot proof"
        );

        IERC20Token(_claimTransactionProof.eth_token_address).mint(
            _claimTransactionProof.eth_receiver,
            _claimTransactionProof.amount
        );
        emit ClaimTransactionCompleted(input, block.timestamp);
    }

    function encodeProof(
        address eth_bridge_address,
        address eth_receiver,
        uint256 amount,
        address eth_token_address,
        uint256 key
    ) public returns (bytes memory) {
        return
            abi.encodePacked(
                eth_bridge_address,
                eth_receiver,
                amount,
                eth_token_address,
                key
            );
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
        ║             GETTER           ║
        ╚══════════════════════════════╝       */

    function getTokenPairOfCosmosToken(
        uint160 _cosmosToken
    ) public view returns (address) {
        return cosmosToEthTokenAddress[_cosmosToken];
    }

    function getTokenPairOfEthToken(
        address _ethToken
    ) public view returns (uint160) {
        return ethToCosmosTokenAddress[_ethToken];
    }

    function getSupportCosmosBridge(
        uint160 _cosmosBridge
    ) public view returns (bool) {
        return isSupportCosmosBridge[_cosmosBridge];
    }
}
