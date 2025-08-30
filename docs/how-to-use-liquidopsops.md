# How to Use LiquidOps

## How to Use LiquidOps: A Step-By-Step Guide

### Step 1: Access LiquidOps

Visit [liquidops.io](http://liquidops.io/) and connect with your wallet.

### Step 2: Get wUSDC and wAR

To supply assets, you need wUSDC and wAR in your wallet:

- wUSDC: Wrap USDC using [https://aox.arweave.net](https://aox.arweave.net/). Just connect your Ethereum wallet, find wUSDC in the assets list and click on bridge. Enter the amount of USDC you want to wrap and confirm it!
- wAR: You can use the same process for getting wAR as with wUSDC.

You can also swap for both tokens directly on Botega.

### Step 3: Supply Assets on LiquidOps

Back on the LiquidOps homepage, click "Supply Assets".
Select wUSDC or wAR, enter the amount you want to supply, then click "Deposit."
Confirm the transaction in your wallet.

After supplying, your tokens will appear under "Position Summary" on the home page. To check interest rates and earnings, use the "Lent Assets" section on the homepage.

### Step 4: Borrow Assets

Next, click on the Borrow Assets button. Select the type and amount of tokens you want to borrow. The Position Summary will display how this borrowing will affect your current position, including:

- Your current collateral
- Your current borrowing capacity
- Your borrowing limit after the transaction

Click on the Submit button to confirm your borrowing request.

### Step 5: Track Your Position

Return to the home page to view your borrowed tokens and the associated interest rate under the Borrowed Assets section. All of your collateral will be listed under the Yielding Assets section.

### Other Features/Sections

Markets Section: View lending and borrowing pools with each token's TVL, available liquidity, borrowed amount, interest rates, and utilization.

Strategies Section: Strategies for shorting and longing tokens using LiquidOps.

## How does LiquidOps Enable Decentralized Leverage in the Arweave and AO Ecosystem?

### Decentralized Leverage

Decentralized leverage in the context of lending protocols refers to the process of using DeFi lending platforms to borrow and increase exposure to an asset without needing a middleman, like a bank or an exchange.

### How does it Work?

First, you deposit a collateral into a lending protocol, in exchange for collateral tokens (like oTokens), which represent your position.

Next, you borrow another asset (usually a stablecoin) using your deposit as collateral. The protocol keeps your loan protected by maintaining a collateralization ratio, making sure the loan stays protected with price drops and market changes.

You then use the borrowed asset to buy more of the original asset, and deposit that again as collateral. This cycle can be repeated several times, increasing your exposure to the original asset, creating decentralized leverage.

This strategy is often utilized by experienced traders and borrowers on lending protocols such as Compound or Aave, but can also be applied with LiquidOps.

### How does LiquidOps Enable Decentralised Leverage in the Arweave and AO Ecosystem?

One of the most widely used use cases of lending and borrowing protocols is decentralized leverage. Experienced DeFi traders frequently use this process; let's break down how it works.

For example, enabling leverage of the Arweave token with LiquidOps lending and borrowing:

First, a user would pledge collateral for a loan in Arweave, and then they would borrow a stablecoin, like USDA.

From the USDA loan, they would buy more Arweave tokens on a decentralised exchange like Botega, gaining more exposure to the Arweave token.

They would then sell the Arweave from the USDA swap once the price increases/decreases to their desired target.

Once sold they would then pay back the initial USDA loan and profit from the difference between the extra exposure in the USDA/Arweave swap from the original loan enabling a greater exposure to the Arweave example due to LiquidOps!

## How do Liquidations Work in Overcollateralized Lending Protocols?

### Traditional Loans

If you take out a loan for a house, the house itself will act as its own collateral. Now if you get into debt, the house itself can be seized to recover said debt.

### Loans in the World of Crypto

In crypto there are overcollateralized loans. Since you can't put up your house, you have to give something up in case you get into debt.

This can't be something that holds the same value as your loan because of the rapid change of price differences between tokens, and also to safeguard the protocol.

### Overcollateralized Loans

This means that you pledge more collateral than the amount borrowed. For example, if it has a 200% collateralisation rate, then two times the value of the loan must be pledged as collateral.

This rate is determined by a risk analysis, in LiquidOps case this is to be made on a case-by-case basis by a protocol governance vote. Collateral supplied to LiquidOps is locked, unless either you pay back your loan or the position is liquidated due to bad debt.

### Liquidation in the Context of Overcollateralized Lending Protocols

When you take out a loan, the protocol will maintain the collateralisation ratio. If the value of the collateral falls significantly, the loan-to-collateral ratio increases.

To safeguard the protocol, a liquidation ratio is set, typically below the initial collateralization ratio, but above 100%. If the collateral value falls below this ratio, liquidation is triggered.

In the liquidation process, the protocol automatically sells a portion (or all) of your collateral to repay the loan. This often involves offering the collateral at a discount to buyers to acquire it.

Liquidations are essential not only to protect the protocol, but to maintain the ecosystem's DeFi stability.