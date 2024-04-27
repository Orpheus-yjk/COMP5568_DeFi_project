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
    camm_addr = "0x83DD4322175d59596b8cF5D4c18B5250c0dCE3Ac";
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



// Init
describe('Init (Mint and approve)', () => {

    it("Init One: Mint some token A and B for camm protocal, and operator account", async() => {
        let operator = accounts[0];
    
        let supplyA_CAMM = 1000100010;
        let supplyB_CAMM = 1000100010;
        await tokenA.mint(camm_addr, supplyA_CAMM);
        await tokenB.mint(camm_addr, supplyB_CAMM);
    
        await tokenA.mint(operator, supplyA_CAMM);
        await tokenB.mint(operator, supplyB_CAMM);
    });
    
    it ("Init Two: Approve CAMM protocol and operator account to move tokanA and tokenB", async() => {
        let operator = accounts[0];
    
        await tokenA.approve(camm_addr,1000100010, {from: operator});    // from who?
        await tokenB.approve(camm_addr,1000100010, {from: operator});
        await tokenA.approve(operator,1000100010, {from: operator});
        await tokenB.approve(operator,1000100010, {from: operator});
    
    });

    it("get base popularity",async() =>{
        let tmp = await camm.getpopularity();
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
        let pop = await camm.getpopularity();
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
            await tokenA.approve(camm_addr,(await tokenA.balanceOf(operator)).toNumber(),{from: operator});
            await tokenA.approve(operator,(await tokenA.balanceOf(operator)).toNumber(),{from: operator});
            await tokenB.approve(camm_addr,(await tokenB.balanceOf(operator)).toNumber(),{from: operator});
            await tokenB.approve(operator,(await tokenB.balanceOf(operator)).toNumber(),{from: operator});
                // console.log("operator balance: ", (await tokenA.balanceOf(operator)).toNumber());
                // console.log("operator allowance: ", (await tokenA.allowance(operator,operator)).toNumber());
                // console.log("camm allowance: ", (await tokenA.allowance(operator,camm_addr)).toNumber());
                
                // console.log("amountIn: ", (await camm.getlastamountIn()).toNumber());
                // console.log("address tokenA: ", tokenA_addr);
                // console.log("?? address tokenA: ", (await camm.getToken0()));
                // console.log("lastpopulairty: ", (await camm.getpopularity()).toNumber());

            await camm.swap(tokenIn, amountIn, 0, {from: operator});    // operator want A for B
        
            let pop = await camm.getpopularity();
            console.log("        ———popularity:",pop.toNumber());
            let fee = pop.toNumber()*amountIn/10000;
            console.log("        ———amountIn", amountIn);
            console.log("        ———Fee", ":",fee);
            console.log("        ———dy", ":",(await camm.getlastdy()).toNumber());
            console.log("        ———getY", ":",(await camm.getlasty1()).toNumber());
        }).timeout(Max_Timeout);    // sleep_time_interval < Max_Timeout
    }
});


describe('TEST END--', () => {

});