// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./StandardToken.sol";

/**
 * @title TokenA
 * @dev Simple ERC20 Token with standard token functions.
 */
contract TokenA is StandardToken {
    string private constant NAME = "TokenA";
    string private constant SYMBOL = "TA";

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
