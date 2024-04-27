// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @dev returns the absolute value of two numbers
 */
library Math {
    function abs(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x - y : y - x;
    }
}

/**
 * @title CAMM
 * @dev construct the Curve-like Market Maker (CAMM) contract
 */
contract CAMM {
    event output(string, uint256);
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 private constant N = 2;

    uint256 private constant A = 2000;

    uint256 private constant DECIMALS = 18;

    uint256 private reserve0;
    uint256 private reserve1;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    /**
     * @dev Initializes the token0 and token1 addresses
     */

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }
    /**
     *@dev Increases the balance of _to address and total supply by _amount
     *@param _to address to mint tokens to
     *@param _amount amount of tokens to mint
     */
    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }
    /**
     * @dev Decreases the balance of _from address and total supply by _amount
     * @param _from address to burn tokens from
     * @param _amount amount of tokens to burn
     */
    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }
    /**
     * @dev Updates the reserves of token0 and token1
     * @param _reserve0 new reserve for token0
     * @param _reserve1 new reserve for token1
     */
    function _update(uint256 _reserve0, uint256 _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    //  exchange rate
    uint256 private floatingPointPrecision = 1e13;
    /**
     * @dev Calculates the exchange rate for the input token and returns the amountOut and fee
     * @param _tokenIn address of the input token
     * @param _amountIn amount of input tokens
     * @return BigamountOut amount of output tokens
     * @return Bigfee fee for the exchange
     */
    function exchange_rate(
        address _tokenIn,
        uint256 _amountIn
    ) external view returns (uint256 BigamountOut, uint256 Bigfee) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");
        uint256 BigAmountIn = floatingPointPrecision * _amountIn;
        uint256 Bigfee = (BigAmountIn * lastPopularity) / popularity_precision;
        // deduct fee
        uint256 BigamountInWithFee = BigAmountIn - Bigfee;
        bool isToken0 = _tokenIn == address(token0);
        (uint256 reserveIn, uint256 reserveOut) = isToken0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);

        uint256 BigreserveOut = reserveOut * floatingPointPrecision;
        uint256 BigreserveIn = reserveIn * floatingPointPrecision;

        // Calculate dy
        uint256 Bigx = (BigreserveIn + BigamountInWithFee);
        uint256 Bigy0 = BigreserveOut;
        uint256 Bigy1 = _getY(Bigx, (BigreserveIn + BigreserveOut));
        uint256 Bigdy = (Bigy0 - Bigy1 - 1);
        BigamountOut = Bigdy;
        return (BigamountOut, Bigfee);
    }
    /**
     * @dev Returns the last popularity value
     * @return lastPopularity last popularity value
     */
    function getpopularity() public view returns (uint256) {
        return lastPopularity;
    }
    /**
     * getToken0 function
     * @dev Returns the token0 address
     * @return token0 IERC20 token0 address
     */
    function getToken0() external view returns (IERC20) {
        return token0;
    }
    /**
     * @dev Returns the token1 address
     * @return token1 IERC20 token1 address
    */
    function getToken1() external view returns (IERC20) {
        return token1;
    }
    /**
     * @dev Returns the reserve0 value
     * @return reserve0 reserve0 value
    */
    function getReserve0() external view returns (uint256) {
        return reserve0;
    }
    /**
     * @dev Returns the reserve1 value
     * @return reserve1 reserve1 value
    */
    function getReserve1() external view returns (uint256) {
        return reserve1;
    }
    /**
     * @dev Returns the address of the contract operator
     * @return msg.sender address of the contract operator
    */
    function getoperator() external view returns (address) {
        return msg.sender;
    }
    /**
     * @dev Returns the address of the protocol
     * @return address(this) address of the protocol
    */
    function getProtocoladdr() external view returns (address) {
        return address(this);
    }
    /**
     * @dev Returns the balance of the protocol address
     * @param addr address to get the balance for
     * @return balance balance of the protocol address
    */
    function getProtocoladdrBalance(
        address addr
    ) external view returns (uint256) {
        return token0.balanceOf(addr);
    }
    /**
    @dev Returns the allowance amount of token0 for the specified owner and spender addresses
    @param owner The address of the token0 owner
    @param spender The address of the spender
    @return allowance The amount of token0 allowed to be spent by the spender on behalf of the owner
    */
    function getApproveToken0(
        address owner,
        address spender
    ) external view returns (uint256) {
        return token0.allowance(owner, spender);
    }
    /**
    @dev Returns the allowance amount of token1 for the specified owner and spender addresses
    @param owner The address of the token1 owner
    @param spender The address of the spender
    @return allowance The amount of token1 allowed to be spent by the spender on behalf of the owner
    */
    function getApproveToken1(
        address owner,
        address spender
    ) external view returns (uint256) {
        return token1.allowance(owner, spender);
    }
    uint256 tmp_reserveIn;
    /**
    @dev Returns the current reserveIn value
    @return reserveIn The current reserveIn value
    */
    function getreserveIn() external view returns (uint256) {
        return tmp_reserveIn;
    }

    uint256 tmp_reserveOut;
    /**
    @dev Returns the current reserveOut value
    @return reserveOut The current reserveOut value
    */
    function getreserveOut() external view returns (uint256) {
        return tmp_reserveOut;
    }

    uint256 tmp_amountIn;
    /**
    @dev Returns the last recorded amountIn value
    @return amountIn The last recorded amountIn value
    */
    function getlastamountIn() external view returns (uint256) {
        return tmp_amountIn;
    }
    uint256 tmp_dy;
    /**
    @dev Returns the last recorded dy value
    @return dy The last recorded dy value
    */
    function getlastdy() external view returns (uint256) {
        return tmp_dy;
    }
    uint256 tmp_y0;
    /**
    @dev Returns the last recorded y0 value
    @return y0 The last recorded y0 value
    */
    function getlasty0() external view returns (uint256) {
        return tmp_y0;
    }
    uint256 tmp_y1;
    /**
    @dev Returns the last recorded y1 value
    @return y1 The last recorded y1 value
    */
    function getlasty1() external view returns (uint256) {
        return tmp_y1;
    }

    /**
    * @dev calculate popularity
    */
    ////last time interval
    uint256 private lastSwapTimestamp; //Last time interval
    uint256 private lastDeltaT = MaxDeltaT * 3;
    //last time popularity
    uint256 private lastPopularity = 500; 

    uint256 private MaxDeltaT = 10 * 24 * 3600; 
    uint256 private MinDeltaT = 1;
    uint256 private interval = 5;

    uint256 private exponent_numbda = 1;
    uint256 private MaxTimefactor = 100;
    uint256 private y_parameter = MaxTimefactor / exponent_numbda; 

    /**
    @dev calculate_Timefactor
    @param x_numerator the numerator of the input value x
    @param x_denominator the denominator of the input value x
    @return TimeFactor the calculated time factor based on the input values
    This function calculates the time factor based on the input values of x numerator and denominator.
    The time factor is calculated using an exponential distribution formula: f(x;numda) = numba * e^(-numdax) = numbda * 1 / (e^[numbdax])
    The function iteratively calculates the value of e^p where p = numbda * x, using the Taylor series expansion of the exponential function.
    The series expansion is terminated when the value of the current term in the series becomes negligible.
    The calculated time factor is then returned.
    */
    function calculate_Timefactor(
        uint256 x_numerator,
        uint256 x_denominator
    ) private view returns (uint256) {
        // exponent distribution:f(x;numda)=numba * e^(-numda*x) = numbda * 1 / (e^[numbda*x])   numbda*x = p
        // uint256 p = numbda * x ;
        // e^p = 1+ p^2/1*2 + p^3/1*2*3 + ... + p^i / i!
        uint256 Maxnum = 1e23;
        uint256 p_numerator = exponent_numbda * x_numerator;
        uint256 p_denominator = x_denominator;

        // e^p = 1+ p^2/1*2 + p^3/1*2*3 + ... + p^i / i!
        uint256 eP = 1 * floatingPointPrecision;

        uint256 item_numerator = 1;
        uint256 item_denominator = 1;

        for (uint256 i = 2; i < 15; i++) {
            item_numerator = item_numerator * p_numerator;
            item_denominator = item_denominator * p_denominator * i;
            if (item_numerator * floatingPointPrecision < item_denominator)
                break;
            eP =
                eP +
                (item_numerator * floatingPointPrecision) /
                item_denominator;
            if (item_numerator > Maxnum && item_denominator > Maxnum) {
                item_numerator = item_numerator / 1e10;
                item_denominator = item_denominator / 1e10;
            }
            if (eP > exponent_numbda * 100 * floatingPointPrecision) break;
        }

        return (exponent_numbda * 100 * floatingPointPrecision) / eP;
    }

    uint256 popularity_precision = 1e6;

    /**
    @dev calculatepopularity
    This function calculates the popularity value based on the time factor of the CAMM contract.
    The popularity value is determined by the time interval between consecutive swaps and the exponential distribution formula.
    The function calculates the time factor using the calculate_Timefactor function, which takes the numerator and denominator of the time interval as input.
    The time factor is then used to calculate the popularity value by multiplying it with the maximum time factor and dividing it by the y_parameter.
    The calculated popularity value is stored in the lastPopularity variable.
    */
    function calculatepopularity() private view returns (uint256) {
        uint256 _deltaT = lastDeltaT;
        uint256 _interval = interval;
        uint256 TimeFactor = calculate_Timefactor(_deltaT, _interval);  //popularity ranges for [0,1000]
        uint256 popularity = (3 * lastPopularity + 70 * TimeFactor) / 10;

        if (popularity > 999) popularity = 999; 
        if (popularity < 100) popularity = 100; 
        return popularity;
    }

    function _getD() private view returns (uint256) {
        uint256 a = A * N; // An^n

        uint256 s; // x_0 + x_1 + ... + x_(n-1)
        uint256 xp0 = token0.balanceOf(address(this)) * 1e18;
        uint256 xp1 = token1.balanceOf(address(this)) * 1e18;
        s = xp0 + xp1;

        uint256 d = s;
        uint256 d_prev;
        for (uint256 i; i < 255; ++i) {
            // p = D^(n + 1) / (n^n * x_0 * ... * x_(n-1))
            uint256 p = d;
            p = (p * d) / (2 * xp0);
            p = (p * d) / (2 * xp1);
            d_prev = d;
            d = ((a * s + 2 * p) * d) / ((a - 1) * d + 3 * p);

            if (Math.abs(d, d_prev) <= 1) {
                return d;
            }
        }
        revert("D didn't converge");
    }

    // calculate dy
    function _getY(uint256 x, uint256 D) private pure returns (uint256) {
        uint256 a = A * 2;
        uint256 d = D;
        uint256 s;
        uint256 c = d;
        s = x;
        c = (c * d) / (2 * x);
        c = (c * d) / (2 * a);
        uint256 b = s + d / a;
        // Newton's method
        uint256 y_prev;
        // Initial guess, y <= d
        uint256 y = d;
        for (uint256 _i; _i < 255; ++_i) {
            if (y <= 1) return 0; // prevent overflow, break for y = 0
            if (2 * y + b < d + 1) return 0; // prevent overflow, break for y = 0
            y_prev = y;
            y = (y * y + c) / (2 * y + b - d);

            if (Math.abs(y, y_prev) <= 1) {
                return y;
            }
        }
        revert("y didn't converge");
    }

    /**
     * @dev Dispenses the fee to the LP providers based on their share of the total supply
     * @param tokenIn IERC20 token for fee transfer
     * @param fee amount of fee to be dispensed
    */
    function dispense_fee_to_LPProvider(IERC20 tokenIn, uint256 fee) private {
        for (uint k = 0; k < LPprovider.length; k++) {
            IERC20(tokenIn).transfer(
                LPprovider[k],
                (fee * balanceOf[LPprovider[k]]) / totalSupply
            );
        }
    }
    /**
    @dev swap
    @param _amountIn The amount of input tokens to be swapped
    @return amountOut The actual amount of output tokens received from the swap
    This function allows users to swap input tokens for output tokens based on the specified amounts.
    The function first checks if the input token is either token0 or token1.
    It then calculates the reserveIn and reserveOut values based on the selected input token.
    The function also calculates the fee to be deducted from the input tokens using the lastPopularity value.
    The actual amount of output tokens received is calculated by deducting the fee from the input tokens.
    The function checks if the actual amount of output tokens received meets the minimum expected amount (amountOutMin).
    If it does, the output tokens are transferred to the specified address (to) and the actual amount of output tokens received is returned.
    Note: This function interacts with the token contracts and updates the reserves and balances accordingly.
    */
    function swap(
        address _tokenIn,
        uint256 _amountIn,
        uint256 minDy
    ) external returns (uint256 amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");

        // swap function
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
         //Record transaction time
        lastDeltaT = block.timestamp - lastSwapTimestamp; 
        if (lastDeltaT > MaxDeltaT) lastDeltaT = MaxDeltaT * 3;
        lastSwapTimestamp = block.timestamp;
        // renew last time Popularity
        lastPopularity = calculatepopularity(); 
        uint256 fee = (_amountIn * lastPopularity) / popularity_precision;
        // deduct fee
        uint256 _amountInWithFee = _amountIn - fee; 

        bool isToken0 = _tokenIn == address(token0);
        (
            IERC20 tokenIn,
            IERC20 tokenOut,
            uint256 reserveIn,
            uint256 reserveOut
        ) = isToken0
                ? (token0, token1, reserve0, reserve1)
                : (token1, token0, reserve1, reserve0);

        emit output("_amountInWithFee", _amountInWithFee);
        IERC20(tokenIn).transferFrom(msg.sender, address(this), _amountIn);

        // Calculate dy
        uint256 x = (reserveIn + _amountInWithFee); 
        uint256 y0 = reserveOut; 

        tmp_reserveIn = reserveIn;
        tmp_reserveOut = reserveOut;
        tmp_y0 = y0;
        uint256 y1 = _getY(x, (reserveIn + reserveOut));
        tmp_y1 = y1;
        // y0 must be >= y1, since x has increased
        // -1 to round down
        uint256 dy = (y0 - y1 - 1);
        require(dy >= minDy, "dy < min");
        IERC20(tokenOut).transfer(msg.sender, dy);

        // record parameters
        tmp_reserveIn = reserveIn;
        tmp_reserveOut = reserveOut;
        tmp_y0 = y0;
        tmp_y1 = y1;
        tmp_dy = dy;
        tmp_amountIn = _amountIn;

        // Fees are distributed to LP providers, less 10% CAMM fees
        dispense_fee_to_LPProvider(tokenIn, fee - fee / 10);

        // Update balances
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );

        amountOut = dy;
    }

    
    address[] private LPprovider;
    /**
    @dev addLiquidity
    @param _amount0 The actual amount of token0 added as liquidity
    @param _amount1 The actual amount of token1 added as liquidity
    This function allows users to add liquidity to the CAMM contract by providing an equal amount of token0 and token1.
    The function takes the desired amounts of token0 and token1 as input.
    It then calculates the amounts of token0 and token1 to be added as liquidity based on the available reserves and the desired amounts.
    The function checks if the calculated amounts of token0 and token1 are less than or equal to the desired amounts.
    If they are, the function transfers the calculated amounts of token0 and token1 from the user's address to the contract's address.
    It then mints an equal amount of liquidity tokens and assigns them to the user's address.
    The actual amounts of token0 and token1 added as liquidity, as well as the amount of liquidity tokens minted, are returned.
    Note: This function interacts with the token contracts and updates the reserves, total supply, and balanceOf mappings accordingly.
    */
    function addLiquidity(
        uint256 _amount0,
        uint256 _amount1,
        uint256 minShares
    ) external returns (uint256 shares) {
        bool flag = false;
        for (uint i = 0; i < LPprovider.length; i++) {
            if (LPprovider[i] == msg.sender) flag = true;
        }
        if (flag == false) LPprovider.push(msg.sender);

        uint256 _xp0 = token0.balanceOf(address(this));
        uint256 _xp1 = token1.balanceOf(address(this));

        // add liquidity
        IERC20(token0).transferFrom(msg.sender, address(this), _amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), _amount1);

        // Update balances
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );

        // calculate current liquidity d0
        uint256 _totalSupply = totalSupply;
        uint256 d0;
        if (_totalSupply > 0) {
            d0 = (_xp0 + _xp1);
        }

        // Calculate new liquidity d1
        uint256 d1 = (_xp0 + _xp1 + _amount0 + _amount1);
        require(d1 > d0, "liquidity didn't increase");

        // deduct fee
        uint256 d2 = (_xp0 + _xp1 + _amount0 + _amount1);

        // Shares to mint = (d2 - d0) / d0 * total supply
        if (_totalSupply > 0) {
            shares = ((d2 - d0) * _totalSupply) / d0;
        } else {
            shares = d2;
        }
        shares = shares;

        require(shares >= minShares, "shares < min");

        _mint(msg.sender, shares);
    }
    /**
    @dev removeLiquidity
    @param _shares The amount of liquidity tokens to be removed
    @param _minAmountsOut0 The min amount of token0 received from removing liquidity
    @param _minAmountsOut1 The min amount of token1 received from removing liquidity
    This function allows users to remove liquidity from the CAMM contract by burning their liquidity tokens.
    The function takes the amount of liquidity tokens to be removed as input.
    It then calculates the amounts of token0 and token1 to be received when removing the liquidity based on the totalSupply and the user's balanceOf.
    The function checks if the calculated amounts of token0 and token1 are greater than zero.
    If they are, the function transfers the calculated amounts of token0 and token1 from the contract's address to the user's address.
    It then burns the specified amount of liquidity tokens from the user's address.
    The amounts of token0 and token1 received from removing the liquidity are returned.
    Note: This function interacts with the token contracts and updates the reserves, total supply, and balanceOf mappings accordingly.
    */
    function removeLiquidity(
        uint256 _shares,
        uint256 _minAmountsOut0,
        uint256 _minAmountsOut1
    ) external returns (uint256 amount0, uint256 amount1) {
        uint256 bal0 = token0.balanceOf(address(this));
        uint256 bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > _minAmountsOut0, "amount0 < min");
        require(amount1 > _minAmountsOut1, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        IERC20(token0).transfer(msg.sender, amount0);
        IERC20(token1).transfer(msg.sender, amount1);
    }
}
/** 
* @dev Interface for the ERC20 standard token
*/
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}
/** 
* @dev inherit from IERC20 interface
*/
contract ERC20 is IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balanceOf[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
