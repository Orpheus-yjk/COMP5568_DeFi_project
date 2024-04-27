// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/** 
 addition: getLogm(), calculatepopularity()
 modification: addLiqudity(), swap()

 Invariant - price of trade and amount of liquidity are determined by this equation

 x * y = k

 Topics
 0. Newton's method x_(n + 1) = x_n - f(x_n) / f'(x_n)
 1. Invariant
 2. Swap
   - Calculate amount of dy : ydx / (x + dx) = dy
   - Calculate dynamic swap fee
   - Dispense 90% fee to LP
 3. Add liquidity
   - No price change, before and after adding liquidity
        x / y = (x + dx) / (y + dy)
   - calculate shares: (L1 - L0) * T / L0 = s
                       (L1 - L0) / L0 = dx / x = dy / y 
 4. Remove liquidity
   - calculate how much dx,dy to remove based on shares: 
           dx = s / T * sqrt(x^2) = s / T * x
           dy = s / T * y

 */
contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 private reserve0;
    uint256 private reserve1;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;

    /**
     * Constructor for the liquidity pool contract
     * @dev Initializes the contract with references to two token contracts using the ERC20 interface.
     * @param _token0 The address of the first token contract.
     * @param _token1 The address of the second token contract.
     */
    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    /**
     * _mint function
     * @dev Mints a specified amount of shares to a given address. This function updates the balance of the address and the total supply of shares.
     * @param _to The address that will receive the minted shares.
     * @param _amount The amount of shares to be minted and added to the recipient's balance.
     */
    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }
    /**
     * _burn function
     * @dev Burns a specified amount of shares from a given address. This function decreases the balance of the address and the total supply of tokens.
     * @param _from The address from which the shares will be burned.
     * @param _amount The amount of shares to be burned, subtracted from the sender's balance and the total supply.
     */
    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    /**
     * _update function
     * @dev Updates the reserves of token0 and token1 stored in the CPAMM liquidity pool. This function sets the private state variables to the new reserve values.
     * @param _reserve0 The new reserve amount for token0.
     * @param _reserve1 The new reserve amount for token1.
     */
    function _update(uint256 _reserve0, uint256 _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    // precise exchange rate * 1e13 (Big exchange rate)
    uint256 private floatingPointPrecision = 1e13;

    /**
     * exchange rate function
     * @dev Calculates the amount of output token and the transaction fee for a given amount of input token.
     *      This function uses higher precision arithmetic to handle small values and prevent rounding errors.
     *      The function first validates the input token and amount, then computes the fee based on token popularity,
     *      and finally calculates the output amount using the constant product formula adjusted for fees.
     * 
     *      Note: The function assumes that the token popularity and reserves are stored with appropriate scaling.
     *
     * @param _tokenIn The address of the input token (must be either token0 or token1).
     * @param _amountIn The amount of the input token.
     * @return BigamountOut The calculated amount of output token, scaled by floatingPointPrecision (1e13).
     * @return Bigfee The calculated fee amount, also scaled by floatingPointPrecision (1e13).
     */
    function exchange_rate(address _tokenIn, uint256 _amountIn)
        external view
        returns (uint256 BigamountOut, uint256 Bigfee)
    {
        require( _tokenIn == address(token0) || _tokenIn == address(token1), "invalid token");
        require(_amountIn > 0, "amount in = 0");

        uint256 BigAmountIn = floatingPointPrecision * _amountIn;

        Bigfee = BigAmountIn* lastPopularity / popularity_precision;
        uint256 BigamountInWithFee = BigAmountIn - Bigfee;    // deduct fee

        // Determine if the input token is token0 or token1, then assign the appropriate pairs of tokens and their reserves.
        // This sets tokenIn and tokenOut to the correct token interfaces, and reserveIn and reserveOut to the corresponding reserves.
        bool isToken0 = _tokenIn == address(token0);
        (uint256 reserveIn, uint256 reserveOut)
        = isToken0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);

        uint256 BigreserveOut = reserveOut * floatingPointPrecision;
        uint256 BigreserveIn = reserveIn * floatingPointPrecision;

        BigamountOut =(BigreserveOut * BigamountInWithFee) / (BigreserveIn + BigamountInWithFee);   // BigamountOut = precise exchange rate * 1e13
        return (BigamountOut, Bigfee);
    }
/** Returning values to the front end*/
    function getpopularity() public view returns(uint256){
        return lastPopularity;
    }

    function getToken0() external view returns(IERC20){return token0;}
    function getToken1() external view returns(IERC20){return token1;}
    function getReserve0() external view returns (uint256) {return reserve0;}
    function getReserve1() external view returns (uint256) {return reserve1;}
    function getoperator() external view returns(address){return msg.sender;}
    function getProtocoladdr() external view returns(address){return address(this);}
    function getProtocoladdrBalance(address addr) external view returns(uint256){return token0.balanceOf(addr);}
    function getApproveToken0(address owner, address spender)external view returns(uint256){return token0.allowance(owner,spender);}
    function getApproveToken1(address owner, address spender)external view returns(uint256){return token1.allowance(owner,spender);}

    uint256 tmp_reserveIn;
    function getreserveIn()external view returns(uint256){return tmp_reserveIn;}

    uint256 tmp_reserveOut;
    function getreserveOut()external view returns(uint256){return tmp_reserveOut;}

    uint256 tmp_amountIn;
    function getlastamountIn()external view returns(uint256){return tmp_amountIn;}

    
    uint256 private lastSwapTimestamp;      //last time interval between the last two transaction
    uint256 private lastDeltaT=MaxDeltaT * 3;
    uint256 private lastPopularity = 500;   // the last popularity

    // CalculateFee based on the frequency of swap
    uint256 private MaxDeltaT = 10 * 24 * 3600; // Setting time range 1s - 10 * 24 * 3600 10 days max.
    uint256 private MinDeltaT = 1;
    // uint256 divisions = 10;
    // uint256 interval = (MaxDeltaT-MinDeltaT-1)/divisions;
    uint256 private interval = 5;

    uint256 private exponent_numbda = 1;
    uint256 private MaxTimefactor = 100;
    uint256 private y_parameter = MaxTimefactor / exponent_numbda;  //The smaller the exponent_numbda is the flatter it is, the larger it is the faster it falls

    /**
     * calculate_Timefactor function
     * @dev Calculates a time-dependent factor based on an exponential decay formula.
     *      The function is used to model decay over time, where the decay rate is determined by the `exponent_numbda`.
     *      It computes the value of the exponential function `e^(-p)` where `p` is the product of `exponent_numbda` and
     *      the ratio `x_numerator / x_denominator`. This is useful in scenarios where fees or other values need to
     *      decrease exponentially over time relative to an input ratio.
     *
     *      The exponential function is approximated using a Taylor series expansion:
     *      `e^p = 1 + p^1/1! + p^2/2! + p^3/3! + ... + p^i/i!`
     *      To manage precision and avoid overflow, the function scales intermediate calculations by `floatingPointPrecision`.
     *
     * @param x_numerator The numerator of the x value, where `x` is a time ratio (or other factor) affecting decay.
     * @param x_denominator The denominator of the x value, keeping calculations in ratio form to avoid precision loss.
     * @return A uint256 value representing the calculated time factor, scaled by `floatingPointPrecision`.
     *         This factor is a function of `x`, representing an exponential decay that can modify other contract values.
     */
    function calculate_Timefactor(uint256 x_numerator, uint256 x_denominator)private view returns(uint256){    
        //  exponential distribution: f(x;numda)=numba * e^(-numda*x) = numbda * 1 / (e^[numbda*x])   numbda*x = p
        // uint256 p = numbda * x ;
        // e^p = 1+ p^2/1*2 + p^3/1*2*3 + ... + p^i / i!
        uint256 Maxnum = 1e23;
        uint256 p_numerator = exponent_numbda * x_numerator;
        uint256 p_denominator = x_denominator;

        // e^p = 1+ p^2/1*2 + p^3/1*2*3 + ... + p^i / i!
        uint256 eP = 1 * floatingPointPrecision;

        uint256 item_numerator = 1;
        uint256 item_denominator = 1;

        for (uint256 i=2;i<15;i++){
            item_numerator = item_numerator * p_numerator;
            item_denominator = item_denominator * p_denominator * i;
            if (item_numerator * floatingPointPrecision < item_denominator)break;
            eP = eP + item_numerator * floatingPointPrecision / item_denominator;
            if (item_numerator > Maxnum && item_denominator > Maxnum){
                item_numerator = item_numerator / 1e10;
                item_denominator = item_denominator / 1e10;
            }
            if (eP > exponent_numbda * 100 * floatingPointPrecision)break;
        }

        return exponent_numbda * 100 * floatingPointPrecision/ eP;
        
    }

    uint256 popularity_precision = 1e6;
    /**
     * calculate popularity
     * @dev Calculates a "popularity" score that decays over time based on the time since the last interaction.
     *      The popularity score is influenced by the time elapsed since the last swap and is adjusted to ensure
     *      that it remains within specified limits. This score could be used to determine dynamic fees or other
     *      parameters that depend on the activity level of a token or user.
     *
     *      The function first calculates a time factor using the `calculate_Timefactor` function which represents
     *      an exponential decay based on the elapsed time (`lastDeltaT`) and a predefined interval. The popularity
     *      score is then updated using a weighted average of the previous popularity and the time factor.
     *
     *      The resulting popularity is scaled to be a value between 100 and 999, which corresponds to a range
     *      of 0.1% to just under 1.0%, using `popularity_precision`.
     *
     * @return popularity The updated popularity score, scaled by `popularity_precision` (1e6), and clamped between
     *         100 (0.1%) and 999 (0.999%).
     */
    function calculatepopularity() private view returns (uint256) {
        uint256 _deltaT = lastDeltaT;
        uint256 _interval = interval;
        uint256 TimeFactor= calculate_Timefactor(_deltaT, _interval);   // [0,100] %%

        //popularity [0,1000]
        uint256 popularity = (3 * lastPopularity + 70 * TimeFactor)/10;

        if (popularity>999)popularity = 999;    //十万分之一千    1%
        if (popularity<100)popularity = 100;    ////十万分之一百 0.1%
        return popularity;
    }
    

    /**
     * square root function
     * @dev Calculates the integer square root of a given number using the Babylonian method (or Heron's method).
     *      This method involves iteratively improving guesses for the square root. The function handles edge cases
     *      where the input number is very small (less than 4).
     * @param y The number to calculate the square root of.
     * @return z The integer square root of the number.
     */
    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
/**
     * @dev Returns the smaller of two values. This utility function is used to determine the minimum of two given numbers.
     * @param x First number to compare.
     * @param y Second number to compare.
     * @return The smaller of the two input values.
     */
    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }

    /**
     * dispense_fee_to_LPProvider function
     * @dev Distributes a specified fee amount to liquidity providers proportionally based on their share of the total shares supply. This function iterates through all liquidity providers and transfers the calculated fee from the swap fee.
     * @param tokenIn The token in which the fees are denominated and will be transferred.
     * @param fee The total amount of fees to be distributed among the liquidity providers.
     */
    function dispense_fee_to_LPProvider(IERC20 tokenIn, uint256 fee) private {
        for (uint k=0;k<LPprovider.length;k++){
           IERC20(tokenIn).transfer(LPprovider[k], fee * balanceOf[LPprovider[k]]/ totalSupply);
        }
    }

    /**
     * swap funciton
     * @dev Executes a token swap from one token to another within the liquidity pool. 
     *      It checks for input token validity and that the input amount is non-zero. 
     *      The function updates reserves, calculates fees based on token popularity, 
     *      and ensures the output amount is above a specified minimum. Fees are partially 
     *      redistributed to liquidity providers.
     * @param _tokenIn The address of the token being swapped in.
     * @param _amountIn The amount of the input token being swapped.
     * @param minDy The minimum acceptable amount of output token that must be received for the swap to be valid.
     * @return amountOut The amount of the output token that will be received from the swap.
     */    
    function swap(address _tokenIn, uint256 _amountIn, uint256 minDy)
        external
        returns (uint256 amountOut)
    {
        require( _tokenIn == address(token0) || _tokenIn == address(token1), "invalid token");
        require(_amountIn > 0, "amount in = 0");

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));

        
        lastDeltaT = block.timestamp - lastSwapTimestamp;   // record the latest transaction interval
        if (lastDeltaT > MaxDeltaT) lastDeltaT = MaxDeltaT * 3;
        lastSwapTimestamp = block.timestamp;
        lastPopularity = calculatepopularity(); // update the last Popularity

        uint256 fee = _amountIn* lastPopularity / popularity_precision;
        uint256 _amountInWithFee = _amountIn - fee;    // deduct fee

     // Determine if the input token is token0 or token1, then assign the appropriate pairs of tokens and their reserves.
     // This sets tokenIn and tokenOut to the correct token interfaces, and reserveIn and reserveOut to the corresponding reserves.
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint256 reserveIn, uint256 reserveOut)
        = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        IERC20(tokenIn).transferFrom(msg.sender, address(this), _amountIn);

        amountOut =(reserveOut * _amountInWithFee) / (reserveIn + _amountInWithFee);

        require(amountOut >= minDy, "dy < min");
        tokenOut.transfer(msg.sender, amountOut);

        // record parameters
        tmp_reserveIn = reserveIn;
        tmp_reserveOut = reserveOut;
        tmp_amountIn=_amountIn;

        _update(
            token0.balanceOf(address(this)), token1.balanceOf(address(this))
        );

        // dispense 90% fee to LP
        dispense_fee_to_LPProvider(tokenIn, fee - fee/10);  //deduct 10% fee for CPAMM
    }
  
    address[] private LPprovider;
    /**
     * add liquidity function
     * @dev Adds liquidity to the pool by depositing two types of tokens (token0 and token1). The function 
     *      calculates the amount of liquidity shares to issue to the provider based on the amounts deposited 
     *      relative to the current pool reserves. It ensures that the liquidity provider is added to the 
     *      LPprovider list if not already included, transfers the tokens into the pool, and mints new shares.
     * @param _amount0 The amount of token0 that the liquidity provider is adding to the pool.
     * @param _amount1 The amount of token1 that the liquidity provider is adding to the pool.
     * @param minShares The minimum number of shares that the liquidity provider must receive for the transaction to succeed.
     * @return shares The number of liquidity shares minted and given to the provider.
     * @return _totalSupply The new total supply of liquidity shares after the transaction.
     */   
    function addLiquidity(uint256 _amount0, uint256 _amount1, uint256 minShares)
        external
        returns (uint256 shares, uint256 _totalSupply)
    {

        bool flag=false;
        for (uint i=0;i<LPprovider.length;i++){
            if (LPprovider[i]==msg.sender)flag=true;
        }
        if (flag==false)LPprovider.push(msg.sender);


        // add liquidity
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        
        if (reserve0 > 0 || reserve1 > 0) {
            require(
                reserve0 * _amount1 == reserve1 * _amount0, "x / y != dx / dy"
            );
        }

        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares >= minShares, "shares < min");
        _mint(msg.sender, shares);

        _totalSupply = totalSupply;

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }
    /**
     * remove liquidity function 
     * @dev Removes liquidity from the pool by burning a specified amount of liquidity shares and returning 
     *      a proportional amount of each token to the liquidity provider. The function ensures that the amounts 
     *      returned are greater than specified minimums to protect against slippage.
     * @param _shares The amount of liquidity shares the provider wants to redeem.
     * @param _minAmountsOut0 The minimum amount of token0 that must be returned to the liquidity provider.
     * @param _minAmountsOut1 The minimum amount of token1 that must be returned to the liquidity provider.
     * @return amount0 The amount of token0 returned to the liquidity provider.
     * @return amount1 The amount of token1 returned to the liquidity provider.
     */
    function removeLiquidity(uint256 _shares, 
        uint256 _minAmountsOut0,
        uint256 _minAmountsOut1)
        external
        returns (uint256 amount0, uint256 amount1)
    {

        uint256 bal0 = token0.balanceOf(address(this));
        uint256 bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > _minAmountsOut0 && amount1 > _minAmountsOut1, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

}

/**
 * @title StandardToken
 * @dev Token to meet the ERC20 standard
 * @notice https://github.com/ethereum/EIPs/issues/20
 */
 interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
    
}

