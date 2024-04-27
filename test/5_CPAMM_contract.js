// This script is designed to test the solidity smart contract - cpamm.sol -- and the various functions within

const CPAMM = artifacts.require("cpamm")
const TOKENA_cpamm = artifacts.require("ERC20Token0_cpamm")
const TOKENB_cpamm = artifacts.require("ERC20Token1_cpamm")

let accounts;

let cpamm;
let tokenA;
let tokenB;

const emptyAddress = '0x00000000000000000000000000000000000000';
let cpamm_addr;
let tokenA_addr;
let tokenB_addr;

contract('cpamm', function (acc) {
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
    cpamm_addr = "0xe897dadef57A2810659576769D2c10b5E2d98Dab";
    tokenA_addr = "0x811351F7bfE8faAe21823A200896fC251DDd00da";
    tokenB_addr = "0x1D2bb5AbE7BD3ab2FcEbea902634849C7717eCC6";
});

// add beforeEach method here:
beforeEach(async () => {
    // need to use the await method like in the last project
    cpamm = await CPAMM.at(cpamm_addr);
    tokenA = await TOKENA_cpamm.at(tokenA_addr);
    tokenB = await TOKENB_cpamm.at(tokenB_addr);
    
    // console.log("Contract Deployer: ", accounts[0]);
});


// 1st Test
it("Test 1: Mint some token A and B for cpamm, and Reserve enough tokens A and B for operator", async() => {
    let operator = accounts[0];

    let supplyA_cpamm = 120;
    let supplyB_cpamm = 109;
    await tokenA.mint(cpamm_addr, supplyA_cpamm);
    await tokenB.mint(cpamm_addr, supplyB_cpamm);

    await tokenA.mint(operator, supplyA_cpamm);
    await tokenB.mint(operator, supplyB_cpamm);
});

// 2nd Test
it ("Test 2: approval for cpamm protocol and operator account to move tokanA and tokenB", async() => {
    let operator = accounts[0];

    await tokenA.approve(cpamm_addr,1000, {from: operator});    // from who?
    await tokenB.approve(cpamm_addr,1000, {from: operator});
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
    console.log("Address of cpamm: ", cpamm_addr);
    console.log("Address of operator: ", operator);
    console.log("allowance by cpamm for operator in token0",(await tokenA.allowance(operator,cpamm_addr)).toNumber());

    await cpamm.swap(tokenA_addr, amountIn, 0, {from: operator});    // operator(1 account) wnat A for B    // from token0 to token1, mindy = 0

    let tmp2 = await tokenA.balanceOf(cpamm_addr);
    console.log("Balance of cpamm ",tmp2.toNumber());
    
    let tmp3 = await tokenA.balanceOf(operator);
    console.log("Balance of operator ",tmp3.toNumber());
    
    let tmp4 = await cpamm.getApproveToken0(operator, cpamm_addr);
    console.log("Allowance of cpamm for operator ",tmp4.toNumber());

    //******************************************************************************swap() */
    await tokenA.approve(cpamm_addr,1000,{from: operator});

});

// 4th Test
it ("Test 4: add liquidity by operator", async() => {
    let operator = accounts[0];

    let _amount0 = 21;
    let _amount1 = 47;
    await cpamm.addLiquidity(_amount0,_amount1, 0, {from: operator});  //minshares = 0
});


// 5th Test
it ("Test 5: remove liquidity by operator", async() => {
    let operator = accounts[0];

    let shares = 19;
    await cpamm.removeLiquidity(shares, 0, 0, {from: operator});     // _minAmountsOut0 = 0, _minAmountsOut1 = 0
});