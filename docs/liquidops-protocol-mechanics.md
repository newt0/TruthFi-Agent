# Protocol Mechanics

## The Jump Rate Interest Model

In Defi lending and borrowing platforms interest rates change based on supply and demand. The Jump Rate Interest Model is designed to keep lending pools liquid by adjusting rates dynamically.

In contrast to traditional models that predict gradual interest rate changes, this model helps maintain liquidity by keeping rates stable under normal conditions and allowing sudden rises when borrowing demand is too high.

### How it works

When utilization is low to moderate, interest rates rise gradually, ensuring predictable costs for borrowers and stable returns for lenders.

However, when utilization reaches a critical level (meaning most available funds are borrowed) the model triggers a sudden spike in interest rates. This jump discourages further borrowing, encourages repayments, and attracts more deposits.

### Why is it useful?

- Prevents liquidity crises: high rates discourage excessive borrowing.
- Adapts to crypto volatility: quickly responds to market demand shifts.
- Optimizes capital efficiency: keeps lending protocols balanced.

By adapting quickly to market shifts, the Jump Rate Interest Model ensures DeFi lending remains efficient, liquid, and sustainable, even in unpredictable conditions.

## The LiquidOps Auction Model

Liquidations possess a key role in DeFi protocols. They are fundamental elements of the protocol's operation, because they ensure that loans without enough collateral are repaid as quickly as possible.

Successful liquidations require competition between liquidators so debts can be settled quickly and efficiently.

Let's see how this process works for LiquidOps!

### Discounted Auction for Liquidations

To make liquidators act fast and handle numerous liquidations, we use an auction model for liquidatable positions.

This model works by offering a predetermined percentage discount compared to the market price – in our case, 5% – at the moment the liquidation is detected. This way, liquidators can acquire tokens at a lower price.

### Time-Based Dutch Auction Mechanism

To encourage fast liquidation, the auction model decreases the discount percentage linearly over a set period, until the discount reaches 0%. This ensures that liquidators compete to settle the debt as quickly as possible.

It is worth noting that larger protocols typically use a "Dutch auction" model, which starts with a high liquidation bonus that gradually decreases over time until a buyer steps in.

## The LQD Token

### The protocol

LiquidOps is an over-collateralized lending and borrowing protocol built on Arweave and AO, which via AO processes that automatically facilitate lending and borrowing transactions.

Users can deposit various tokens into the protocol like AR, USDC, USDT and ETH. In return, they receive tokens representing their stake in the liquidity pool.

The value of these tokens increases over time as interest accrues, enabling users to earn passive income on their deposits.

### The purpose and function of LQD token

LQD represents a huge transformation in LiquidOps history, turning it from a developer led platform into a community governed protocol.

It serves several critical functions within the LiquidOps ecosystem:

#### 1. Governance token

The primary purpose of the LQD token is to enable governance over the LiquidOps protocol.

LQD enables users to participate in the decision-making process of the platform. Holders of LQD can propose changes to the protocol, such as adding new assets, adjusting interest rates, or modifying collateral factors.

#### 2. Proposal creation and voting

Anybody with LQD can propose a governance action, these are simple or complex sets of actions, such as:

- Adding support for a new asset
- Changing an asset's collateral factor,
- Changing a market's interest rate model
- Changing any other parameter or variable of the protocol.

The governance process follows a structured approach:

- All proposals are subject to a voting period.
- Any address with voting power can cast votes for or against the proposal.
- If a majority of votes support the proposal, it is queued for implementation.

#### 3. Vote delegation

One unique capability is that users who hold LQD have the ability to delegate their votes to someone of their choosing.

This could come in handy if LQD holders want to solicit expertise from their network. This feature ensures that even passive holders can participate in governance through trusted delegates.

#### 4. User incentivization

LQD tokens are distributed among the various LiquidOps money markets based on the dollar value of assets lent/borrowed.

The LiquidOps token LQD, serves as both a governance mechanism and an incentive system that aligns user interests with protocol development.

By distributing decision making power to token holders, LQD ensures that LiquidOps can evolve and adapt based on community needs rather than centralised authority.

The token's dual function as both a governance tool and a reward mechanism creates a sustainable ecosystem where active participation is incentivised and protocol improvements benefit all stakeholders.