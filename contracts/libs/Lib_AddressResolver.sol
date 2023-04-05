// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Lib_AddressManager} from "./Lib_AddressManager.sol";

/**
 * @title Lib_AddressResolver
 * @notice Lib_AddressResolver will resolve address contract from Lib_AddressManager
 */
abstract contract Lib_AddressResolver is Initializable {
    Lib_AddressManager public libAddressManager;

    function __Lib_AddressResolver_init(address _libAddressManager)
        internal
        onlyInitializing
    {
        libAddressManager = Lib_AddressManager(_libAddressManager);
    }

    /**
     * @dev get address of contract by its Name
     */
    function resolve(string memory _name) public view returns (address) {
        return libAddressManager.getAddress(_name);
    }
}
