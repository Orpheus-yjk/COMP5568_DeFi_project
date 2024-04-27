# Implementation of a DEX following the Curve AMM
- Ganache test network
-  Build and deploy two ERC20 tokens
- Build a coin swap protocol, with two liquidity pools following two different market
- making strategies:
  - Constant Product Automated Market Making (AMM)
  - Curve-like AMM
- Liquidity pools (LPs) should provide:
  - swap() function to swap two tokens
  - ability to add liquidity into the pool, in exchange for newly minted LP tokens
  - Exchange fees proportional to popularity of the tokens! More fees for LP providers
- Build a web3 interface that connects to the user’s wallet (in Javascript)
  - Let user choose LP
  - Select coins to swap
  - See current (estimated) exchange rate based on blockchain status
  - Enter amount to exchange
  - Perform the exchange

# Grading Rubric
- Demonstrates a well-developed focus, thorough points of development, and a 
- logical pattern of organization of ideas and concepts.
- Supports result with images and data
- Illustrate key parts/mechanisms of the code
- Proper background and references
- Completeness, correct format, appropriate language and accuracy
- Code is well documented, runs, is not plagiarized, proper references are made

# Highlighting design component
**Athrimatic of constant product AMM**
![这是图片](pic/constant%20product%20AMM.png "constant product AMM")
**Design of CPAMM swap function**
![这是图片](pic/CPAMM%20swap%20function.png "CPAMM swap function")
**Athrimatic of Curve like AMM**
![这是图片](pic/Curve%20like%20AMM.png "Curve like AMM")
**Design of CLAMM swap function**
![这是图片](pic/CLAMM%20swap%20function.png "CLAMM swap function")
**Design of dynamic fee with exponetial distribution in the language which only accepts integer**
![这是图片](pic/Dynamic%20Exchange%20fee.png "Dynamic exchange fee")
**Project presentation Demo**
![这是图片](pic/Decentralize%20exchange.png "Decentralized exchange")
