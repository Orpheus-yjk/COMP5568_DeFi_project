// This script is designed to test the solidity smart contract - CPAMM.sol -- and the various functions within

const CPAMM = artifacts.require("CPAMM")
const TOKENA_CPAMM = artifacts.require("ERC20Token0_CPAMM")
const TOKENB_CPAMM = artifacts.require("ERC20Token1_CPAMM")

let accounts;

let cpamm;
let tokenA;
let tokenB;

const emptyAddress = '0x00000000000000000000000000000000000000';
let cpamm_addr;
let tokenA_addr;
let tokenB_addr;

contract('CPAMM', function (acc) {
    accounts = acc; // all local accounts
    ///Available Accounts
    cpamm_addr = "0xCd6dC4a75C3bC81Af84DDFaa3faD82a66b2D7831";
    tokenA_addr = "0x1028Cb5021b3306278A75F58eb3450Ef1e45E5e5";
    tokenB_addr = "0xAD6F328A4570cc93625fdF3D87a57B7d40ac0D87";
});



// add beforeEach method here:
beforeEach(async () => {
    // need to use the await method like in the last project
    cpamm = await CPAMM.at(cpamm_addr);
    tokenA = await TOKENA_CPAMM.at(tokenA_addr);
    tokenB = await TOKENB_CPAMM.at(tokenB_addr);
    
    // console.log("Contract Deployer: ", accounts[0]);
});



// Init
describe('Init (Mint and approve)', () => {

    it("Init One: Mint some token A and B for CPAMM protocal, and operator account", async() => {
        let operator = accounts[0];
    
        let supplyA_CPAMM = 1000100010;
        let supplyB_CPAMM = 1000100010;
        await tokenA.mint(cpamm_addr, supplyA_CPAMM);
        await tokenB.mint(cpamm_addr, supplyB_CPAMM);
    
        await tokenA.mint(operator, supplyA_CPAMM);
        await tokenB.mint(operator, supplyB_CPAMM);
    });
    
    it ("Init Two: Approve CPAMM protocol and operator account to move tokanA and tokenB", async() => {
        let operator = accounts[0];
    
        await tokenA.approve(cpamm_addr,1000100010, {from: operator});    // from who?
        await tokenB.approve(cpamm_addr,1000100010, {from: operator});
        await tokenA.approve(operator,1000100010, {from: operator});
        await tokenB.approve(operator,1000100010, {from: operator});
    
    });

    it("get base popularity",async() =>{
        let tmp = await cpamm.getpopularity();
        console.log("        ———Base popularity: ", tmp.toNumber());
    });
    
});



    let deltaT = 2;  // time interval(s)
    let sleep_time_interval = (deltaT)*1000;  // time interval(s->ms)
    let multiplier = 5;
    let amountIn = 5; // times multiplier each round
    let tokenIn = tokenA_addr;

    let Max_Timeout = 1000*1000; //1000s time out

    function sleep(ms) {
        return new Promise(val => setTimeout(val, ms));
    }



describe('Swap and get Popularity: origin popularity, and transactions (number from 1 to 10)', () => {

    // Before Swap
    it("initial popularity / Before Swap:", async() => {
        let pop = await cpamm.getpopularity();
        console.log("        ———popularity Origin:",pop.toNumber());
    }).timeout(Max_Timeout);
    

    // Swap (time from 1 to 10)
    let round;

    let Rounds = ["1","2","3","4","5","6","7","8","9","10"];
    for (var i=0;i<Rounds.length;i++)
    {
        // Swap i_th
        round = Rounds[i];
        it ("Swap "+round+" / Time interval = "  +  "("+sleep_time_interval.toString()+"ms"+")"  +  ":", async() => {

            let operator = accounts[0];
            amountIn = amountIn*multiplier; // times multiplier each round
        
            await sleep(sleep_time_interval);
            
            if (tokenIn == tokenA_addr){
                if ((await tokenA.balanceOf(operator)).toNumber()< amountIn){
                    await tokenA.mint(operator,amountIn,{from: operator});
                }
            } else if (tokenIn == tokenB_addr){
                if ((await tokenB.balanceOf(operator)).toNumber()< amountIn){
                    await tokenB.mint(operator,amountIn,{from: operator});
                }
            }
            await tokenA.approve(cpamm_addr,(await tokenA.balanceOf(operator)).toNumber(),{from: operator});
            await tokenA.approve(operator,(await tokenA.balanceOf(operator)).toNumber(),{from: operator});
            await tokenB.approve(cpamm_addr,(await tokenB.balanceOf(operator)).toNumber(),{from: operator});
            await tokenB.approve(operator,(await tokenB.balanceOf(operator)).toNumber(),{from: operator});
                // console.log("operator balance: ", (await tokenA.balanceOf(operator)).toNumber());
                // console.log("operator allowance: ", (await tokenA.allowance(operator,operator)).toNumber());
                // console.log("cpamm allowance: ", (await tokenA.allowance(operator,cpamm_addr)).toNumber());
                
                // console.log("amountIn: ", (await cpamm.getlastamountIn()).toNumber());
                // console.log("address tokenA: ", tokenA_addr);
                // console.log("?? address tokenA: ", (await cpamm.getToken0()));
                // console.log("lastpopulairty: ", (await cpamm.getpopularity()).toNumber());

            await cpamm.swap(tokenIn, amountIn, 0, {from: operator});    // operator want A for B
        
            let pop = await cpamm.getpopularity();
            console.log("        ———popularity:",pop.toNumber());
            let fee = pop.toNumber()*amountIn/10000;
            console.log("        ———amountIn", amountIn);
            console.log("        ———Fee", ":",fee);
        }).timeout(Max_Timeout);    // sleep_time_interval < Max_Timeout
    }
});


describe('TEST END--', () => {

});