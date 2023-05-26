// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MerkleTreeWithHistory is Initializable {
    uint256 public ROOT_HISTORY_SIZE;

    uint256 public levels;
    uint256 public currentDepositRoot;

    mapping(uint256 => uint256) public depositRoots;

    /*╔══════════════════════════════╗
      ║          CONSTRUCTOR         ║
      ╚══════════════════════════════╝*/

    function __MerkleTreeWithHistory_init(uint256 _levels)
        internal
        onlyInitializing
    {
        require(_levels > 0, "_levels should be greater than zero");
        require(_levels < 40, "_levels should be less than 40");
        levels = _levels;
        ROOT_HISTORY_SIZE = 10;
        currentDepositRoot = 0;
        
        depositRoots[currentDepositRoot] = 0;
    }

    /*  ╔══════════════════════════════╗
      ║        ADMIN FUNCTIONS       ║
      ╚══════════════════════════════╝ */

    function _insert(uint256 _depositRoot) internal returns (bool) {
        uint256 newRootClaimLeaf = (currentDepositRoot + 1) %
            ROOT_HISTORY_SIZE;
        currentDepositRoot = newRootClaimLeaf;
        depositRoots[currentDepositRoot] = _depositRoot;
        return true;
    }


    function _setRootHistorySize(uint256 _rootHistorySize) internal {
        ROOT_HISTORY_SIZE = _rootHistorySize;
    }

    /*  ╔══════════════════════════════╗
      ║        GETTER       ║
      ╚══════════════════════════════╝ */
    /**
    @dev Whether the root is present in the root history
  */
    function isKnownDepostRoot(uint256 _depositRoot) public view returns (bool) {
        if (_depositRoot == 0) {
            return false;
        }
        uint256 _currentDepositRoot = currentDepositRoot;
        uint256 i = _currentDepositRoot;
        do {
            if (_depositRoot == depositRoots[i]) {
                return true;
            }
            if (i == 0) {
                i = ROOT_HISTORY_SIZE;
            }
            i--;
        } while (i != _currentDepositRoot);
        return false;
    }

    /**
    @dev Returns the last root claim
  */
    function getLastDepositRoot() public view returns (uint256) {
        return depositRoots[currentDepositRoot];
    }
}
