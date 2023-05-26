// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC20Token {
    function mint(address _to, uint256 _amount) external;

    function burn(address _owner, uint256 _amount) external;
}
