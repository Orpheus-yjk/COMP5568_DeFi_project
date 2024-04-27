// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title ERC20 interface
 *  @notice https://github.com/ethereum/EIPs/issues/20
 */
interface ERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * @title StandardToken
 * @dev Token to meet the ERC20 standard
 * @notice https://github.com/ethereum/EIPs/issues/20
 */
contract StandardToken is ERC20 {
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowed;

    uint256 internal _totalSupply;
    string internal _name;
    string internal _symbol;

    /**
     * @dev Returns the name of the token.
     */
    function name() public view override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract.
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    /**
     * @dev Returns the total supply of tokens.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * balanceOf function
     * @dev Gets the balance of the specified address.
     * @param _owner address to get balance of.
     * @return uint256 amount owned by the address.
     */
    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }

    /**
     * transfer function
     * @dev Transfers tokens to a specified address
     * @param _to address to transfer to.
     * @param _value amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * Actual implementation of the transfer function from any to any address
     * @dev Transfers tokens for a specified address
     * @param _from address to transfer from.
     * @param _to address to transfer to.
     * @param _value amount to be transferred.
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(_balances[_from] >= _value, "ERC20: transfer amount exceeds balance");

        _balances[_from] -= _value;
        _balances[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    /**
     * transferFrom function
     * @dev Transfers tokens from one address to another after approval
     * @param _from address to send tokens from
     * @param _to address to transfer to
     * @param _value amout of tokens to be transfered
     */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        uint256 _allowance = allowance(_from, msg.sender);
        require(_allowance >= _value, "ERC20: insufficient allowance");

        _approve(_from, msg.sender, _allowance - _value);

        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * approve function
     * @dev Approves address to spend amount of tokens
     * @param _spender address to spend the funds.
     * @param _value amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public override returns (bool) {
        // To change the approve amount you first have to reduce the addresses`
        // allowance to zero by calling `approve(_spender, 0)` if it is not
        // already 0 to mitigate the race condition described here:
        // @notice https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        assert((_value == 0) || (allowance(msg.sender, _spender) == 0));

        _approve(msg.sender, _spender, _value);
        return true;
    }

    /**
     * Actual logic of the approve function
     * @dev Approves address to spend amount of tokens on behalf of another address
     * @param _owner address to take the funds from.
     * @param _spender address to spend the funds.
     * @param _value amount of tokens to be spent.
     */
    function _approve(address _owner, address _spender, uint256 _value) internal virtual {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        _allowed[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);
    }

    /**
     * allowance function
     * @dev Checks how much the owner of tokens has allowed the spender to spend
     * @param _owner address which owns the funds.
     * @param _spender address which will spend the funds.
     * @return A uint256 specifing the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowed[_owner][_spender];
    }
}
