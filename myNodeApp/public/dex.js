const cpammAddress = "0x70D1Bc286614A0B16c65dbd1AE07DB6aaB52DF20"
const clammAddress = "0x55c71aED15deED6F9282E3398Bf066881916a158"
let userAddress = '0xF3711f72634BEE45555f826eD416ebc43c72700F'
let tokenAAddress = '0xF014a2480B03D624280973e30027761355bEA85C'
let tokenBAddress = '0x2408Aa4Ea4F0843F9964f482030174aB7D392902'

const cpammABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_token0",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_token1",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_amount0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minShares",
				"type": "uint256"
			}
		],
		"name": "addLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "shares",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_totalSupply",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_tokenIn",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amountIn",
				"type": "uint256"
			}
		],
		"name": "exchange_rate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "BigamountOut",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Bigfee",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "getApproveToken0",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "getApproveToken1",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProtocoladdr",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "getProtocoladdrBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getReserve0",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getReserve1",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getToken0",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getToken1",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getlastamountIn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getoperator",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getpopularity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getreserveIn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getreserveOut",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_shares",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minAmountsOut0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minAmountsOut1",
				"type": "uint256"
			}
		],
		"name": "removeLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amount1",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_tokenIn",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minDy",
				"type": "uint256"
			}
		],
		"name": "swap",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "token0",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "token1",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
const clammABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_token0",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_token1",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "output",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_amount0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount1",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minShares",
				"type": "uint256"
			}
		],
		"name": "addLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "shares",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_tokenIn",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amountIn",
				"type": "uint256"
			}
		],
		"name": "exchange_rate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "BigamountOut",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "Bigfee",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "getApproveToken0",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "getApproveToken1",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProtocoladdr",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "getProtocoladdrBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getReserve0",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getReserve1",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getToken0",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getToken1",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getlastamountIn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getlastdy",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getlasty0",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getlasty1",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getoperator",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getpopularity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getreserveIn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getreserveOut",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_shares",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minAmountsOut0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minAmountsOut1",
				"type": "uint256"
			}
		],
		"name": "removeLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amount0",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amount1",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_tokenIn",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minDy",
				"type": "uint256"
			}
		],
		"name": "swap",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "token0",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "token1",
		"outputs": [
			{
				"internalType": "contract IERC20",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
const erc20ABI = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_spender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
let exchangeRate;
let cpamm;
let clamm;
let connectAMM;
let tokenA;
let tokenB;
let fromAddress;
let toAddress;
let fromTokenName;
let toTokenName;
let myPieChart1;
let myPieChart2;
let swapInfo = [];
let bigFee;
let popularity;



window.onload = function() {
    // Connect token A and token B contract to approve the user to transfer the token
    let provider = new ethers.providers.Web3Provider(window.ethereum);
    let signer = provider.getSigner();
    tokenA = new ethers.Contract(tokenAAddress, erc20ABI, signer);
    tokenB = new ethers.Contract(tokenBAddress, erc20ABI, signer);
    cpamm = new ethers.Contract(cpammAddress, cpammABI, signer);
    clamm = new ethers.Contract(clammAddress, clammABI, signer);
    getExchangeRate();
    chooseLP();
    findTheRelationship();
};



async function connectWallet(){
    if (typeof window.ethereum ==="undefined"){
      alert("Please install wallet first!");
      return;
    }
    let accounts = await window.ethereum.request({method:'eth_requestAccounts'});
    if (accounts.length > 0) {
      let accountFound = accounts.includes(userAddress.toLowerCase());
      if(accountFound) {
        alert('The wallet is connected to the user account!');
        document.getElementById("walletAddress").innerText = "Account: " + userAddress;
      } else {
        alert("The user is not found in the connected wallet");
      }
    } else {
      alert("No accounts found. Please unlock your wallet.");
    }
  }
  

// Let user choose LP
async function chooseLP(){
    let lp = document.getElementById("lp").value;
    if (lp == "0"){
        connectAMM = cpamm
    } else if (lp == "1"){
        connectAMM = clamm
    } else {
        alert("Please choose a valid LP");
    }
	updatePoolChart();
}

function findTheRelationship(){
   
    let fromToken = document.getElementById("swap-from").value;
    let toToken = document.getElementById("swap-to").value;
    if (fromToken === "0" && toToken === "0") {
        fromAddress = tokenAAddress;
        toAddress = tokenAAddress;
        fromTokenName = "A"
        toTokenName = "A"
    } else if(fromToken === "1" && toToken === "1") {
        fromAddress = tokenBAddress;
        toAddress = tokenBAddress;
        fromTokenName = "B"
        toTokenName = "B"
    } else if(fromToken === "0" && toToken === "1") {
        fromAddress = tokenAAddress;
        toAddress = tokenBAddress;
        fromTokenName = "A"
        toTokenName = "B"
    } else if(fromToken === "1" && toToken === "0") {
        fromAddress = tokenBAddress;
        toAddress = tokenAAddress;
        fromTokenName = "B"
        toTokenName = "A"
    } else {
        alert("Please choose a valid token");
    }
    return fromAddress, toAddress, fromTokenName, toTokenName;
}

// See current (estimated) exchange rate based on blockchain status
async function getExchangeRate(){
    fromAddress, toAddress, fromTokenName, toTokenName = findTheRelationship();
	let fromAmount = document.getElementById("swap-from-amount").value;
    if (fromTokenName === toTokenName) {
        exchangeRate = 1*fromAmount;
    } else {
        returnV = await connectAMM.exchange_rate(fromAddress, fromAmount);
		exchangeRate = returnV[0]/ 10**13;
		bigFee = returnV[1]/ 10**13;

    }
	popularity = await connectAMM.getpopularity();
	document.getElementById('exchange-rate').innerHTML = "1 Token" + fromTokenName + ' = ' + exchangeRate/fromAmount + " Token" + toTokenName;
	return exchangeRate;
}

// calculate how much token A you will get if you provide x amount of token B
function calculateAmount(input) {
	let fromAmount = document.getElementById("swap-from-amount").value;
	let toAmount = document.getElementById("swap-to-amount").value;
	let fromToken = document.getElementById("swap-from").value;
	let toToken = document.getElementById("swap-to").value;
	if (fromAmount === "") {
		return;
	}

	getExchangeRate().then(exchangeRate => {
		if (input === 'from') {
			if (fromToken === "0") {
				document.getElementById("swap-to-amount").value = exchangeRate;
			} else if (fromToken === "1") {
				document.getElementById("swap-to-amount").value = exchangeRate;
			} else {
				alert("Please enter a valid token");
			}
		} else if (input === 'to') {
			if (toToken === "0") {
				document.getElementById("swap-to-amount").value = exchangeRate;
			} else if (toToken === "1") {
				document.getElementById("swap-to-amount").value = exchangeRate;
			} else {
				alert("Please enter a valid token");
			}
		}
	}).catch(error => {
		console.error("Get rate failed:", error);
        alert("Get rate failed. Please check the console for details.");
	});
}

function updateSwapInfo() {
    let swapInfoDiv = document.getElementById("swap-info");
    swapInfoDiv.innerHTML = ""; 

    swapInfo.forEach(info => {
        let p = document.createElement("p");
        p.textContent = info;
        swapInfoDiv.appendChild(p);
    });
}

// show the result of the swap
async function swap(){
    let fromAmount = document.getElementById("swap-from-amount").value;
    let toAmount = document.getElementById("swap-to-amount").value;
    fromAddress, toAddress, fromTokenName, toTokenName = findTheRelationship();
    if (fromTokenName === toTokenName) {
        alert("You can't swap the same token!");
        return;
    }
	getExchangeRate();
    let tx = await connectAMM.swap(fromAddress, fromAmount, 0);
    await tx.wait();
    alert("Swap successful! You swap" + fromAmount + " " + fromTokenName + " for " + toAmount + " " + toTokenName);
    
    
    // let transactionFee = tx.getTransactionFee();
	let info;
	if(connectAMM == cpamm) {
		info = "Swap " + fromAmount + " " + fromTokenName + " for " + toAmount + " " + toTokenName + " (Popularity:" + popularity + ",Tx_fee:"+ bigFee+ ",cpamm)";
	} else if(connectAMM == clamm) {
		info = "Swap " + fromAmount + " " + fromTokenName + " for " + toAmount + " " + toTokenName + " (Popularity:" + popularity +",Tx_fee:"+ bigFee+",clamm)";
	}

    // let info = "Swap " + fromAmount + " " + fromTokenName + " for " + toAmount + " " + toTokenName + ". Gas Fee: " + gasFee + ". Popularity: " + popularity+ ". transaction Fee: " + transactionFee;
    
    swapHistory.push(info);
    updateSwapHistory();
	updatePoolChart();
}

let myPieChart; 
let swapHistory = []; 

async function updatePoolChart() {
    try {
        let reserve0, reserve1;
        if (connectAMM === cpamm) {
            reserve0 = await cpamm.getReserve0();
            reserve1 = await cpamm.getReserve1();
        } else if (connectAMM === clamm) {
            reserve0 = await clamm.getReserve0();
            reserve1 = await clamm.getReserve1();
        }

        const data = {
            labels: ['Token A', 'Token B'],
            values: [parseFloat(reserve0), parseFloat(reserve1)]
        };

        const pieData = {
            labels: data.labels,
            datasets: [{
                data: data.values,
                backgroundColor: ['#4682b4', 'blue']
            }]
        };

        if (myPieChart) {
            myPieChart.data = pieData;
            myPieChart.update();
        } else {
            const ctx = document.getElementById('pool-pie-chart').getContext('2d');
            myPieChart = new Chart(ctx, {
                type: 'pie',
                data: pieData,
            });
        }
    } catch (error) {
        console.error("An error occurred while updating pool chart:", error);
    }
}

function updateSwapHistory() {
    let swapHistoryDiv = document.getElementById("swap-info");
    swapHistoryDiv.innerHTML = ""; 

    swapHistory.forEach(swap => {
        let p = document.createElement("p");
        p.textContent = swap;
        swapHistoryDiv.appendChild(p);
    });
}






