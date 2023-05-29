// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract ERC20Token is
    ERC20Upgradeable,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    address internal ethBridge;

    /*╔══════════════════════════════╗
      ║            EVENTS            ║
      ╚══════════════════════════════╝*/

    event Mint(address indexed account, uint256 amount);
    event Burn(address indexed account, uint256 amount);

    /*╔══════════════════════════════╗
      ║           MODIFIER           ║
      ╚══════════════════════════════╝*/
    modifier onlyBridgeAdmin() {
        require(
            msg.sender == ethBridge || msg.sender == owner(),
            "Only bridge or owner can mint!"
        );
        _;
    }

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function initialize(
        string memory _name,
        string memory _symbol,
        address _ethBridge
    ) public initializer {
        require(ethBridge == address(0), "ERC20 token is initialized");
        ethBridge = _ethBridge;
        __ERC20_init(_name, _symbol);
        __Pausable_init();
        __Ownable_init();
    }

    /**
     * Pause relaying.
     */

    function pauseContract() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }

    /*╔══════════════════════════════╗
      ║       ADMIN FUNCTIONS        ║
      ╚══════════════════════════════╝*/

    function setBridgeAdmin(address _bridgeAdmin) external onlyOwner {
        ethBridge = _bridgeAdmin;
    }

    function mint(
        address _to,
        uint256 _amount
    ) external onlyBridgeAdmin whenNotPaused {
        _mint(_to, _amount);

        emit Mint(_to, _amount);
    }

    function burn(
        address _owner,
        uint256 _amount
    ) external onlyBridgeAdmin whenNotPaused {
        _burn(_owner, _amount);

        emit Burn(_owner, _amount);
    }

    /*╔══════════════════════════════╗
      ║            GETTERS           ║
      ╚══════════════════════════════╝*/

    function getEthBridge() external view returns (address) {
        return ethBridge;
    }
}
