// This script is designed to test the solidity smart contract - CAMM.sol -- and the various functions within

const CAMM = artifacts.require("CAMM")
const TOKENA_CAMM = artifacts.require("ERC20Token0_CAMM")
const TOKENB_CAMM = artifacts.require("ERC20Token1_CAMM")

let accounts;

let camm;
let tokenA;
let tokenB;

const emptyAddress = '0x00000000000000000000000000000000000000';
let camm_addr;
let tokenA_addr;
let tokenB_addr;

contract('CAMM', function (acc) {
    accounts = acc; // all local accounts
    ///Available Accounts
    ///==================
    ///(0) 0x........................................
    ///(1) 
    ///(2) 
    ///(3) 
    ///(4) 
    ///(5) 
    ///(6) 
    ///(7) 
    ///(8) 
    ///(9) 
    camm_addr = "0x75A1c0bbF1aE5159CE44B78aE44b5a7a5085A377";
    tokenA_addr = "0x733404e48933FB0FB2592448dea813BC6A0b2a4A";
    tokenB_addr = "0x99783a1BF8A04a7B32ddaf389D28845043EA71a3";
});

// add beforeEach method here:
beforeEach(async () => {
    // need to use the await method like in the last project
    camm = await CAMM.at(camm_addr);
    tokenA = await TOKENA_CAMM.at(tokenA_addr);
    tokenB = await TOKENB_CAMM.at(tokenB_addr);
    
    // console.log("Contract Deployer: ", accounts[0]);
});


// 1st Test
it("Test 1: Mint some token A and B for camm, and Reserve enough tokens A and B for operator", async() => {
    let operator = accounts[0];

    let supplyA_CAMM = 120;
    let supplyB_CAMM = 109;
    await tokenA.mint(camm_addr, supplyA_CAMM);
    await tokenB.mint(camm_addr, supplyB_CAMM);

    await tokenA.mint(operator, supplyA_CAMM);
    await tokenB.mint(operator, supplyB_CAMM);
});

// 2nd Test
it ("Test 2: approval for CAMM protocol and operator account to move tokanA and tokenB", async() => {
    let operator = accounts[0];

    await tokenA.approve(camm_addr,1000, {from: operator});    // from who?
    await tokenB.approve(camm_addr,1000, {from: operator});
    await tokenA.approve(operator,1000, {from: operator});
    await tokenB.approve(operator,1000, {from: operator});

});

// 3rd Test
it ("Test 3: swap event by operator", async() => {

    //******************************************************************************init */
    let operator = accounts[0];
    let amountIn = 17;


    //******************************************************************************log */
    console.log("tokenA address",tokenA_addr);
    console.log("Address of CAMM: ", camm_addr);
    console.log("Address of operator: ", operator);
    console.log("allowance by camm for operator in token0",(await tokenA.allowance(operator,camm_addr)).toNumber());

    await camm.swap(tokenA_addr, amountIn, 0, {from: operator});    // operator(1 account) wnat A for B    // from token0 to token1, mindy = 0

    let tmp2 = await tokenA.balanceOf(camm_addr);
    console.log("Balance of camm ",tmp2.toNumber());
    
    let tmp3 = await tokenA.balanceOf(operator);
    console.log("Balance of operator ",tmp3.toNumber());
    
    let tmp4 = await camm.getApproveToken0(operator, camm_addr);
    console.log("Allowance of camm for operator ",tmp4.toNumber());

    //******************************************************************************swap() */
    await tokenA.approve(camm_addr,1000,{from: operator});

});

// 4th Test
it ("Test 4: add liquidity by operator", async() => {
    let operator = accounts[0];

    let _amount0 = 21;
    let _amount1 = 17;
    await camm.addLiquidity(_amount0,_amount1, 0, {from: operator});  //minshares = 0
});


// 5th Test
it ("Test 5: remove liquidity by operator", async() => {
    let operator = accounts[0];

    let shares = 19;
    await camm.removeLiquidity(shares, 0, 0, {from: operator});     // _minAmountsOut0 = 0, _minAmountsOut1 = 0
});