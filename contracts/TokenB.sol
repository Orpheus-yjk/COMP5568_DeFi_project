// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./StandardToken.sol";

/**
 * @title TokenB
 * @dev Simple ERC20 Token with standard token functions.
 */
contract TokenB is StandardToken {
    string private constant NAME = "TokenB";
    string private constant SYMBOL = "TB";

    uint256 private INITIAL_SUPPLY = 500 * 10**decimals();

    /**
     * Token Constructor
     * @dev Create and issue tokens to msg.sender.
     */
    constructor() {
        _name = NAME;
        _symbol = SYMBOL;
        _totalSupply = INITIAL_SUPPLY;
        _balances[msg.sender] = INITIAL_SUPPLY;
    }
}
