This agent operates according to customizable risk profiles defined by the user, dynamically adjusting strategies to maximize capital efficiency and yield potential. Users can spawn an unlimited number of Portfolio Agents each with unique configurations tailored to specific financial objectives.

###

Functionalities:

- **Asset Management**: Automatically receives and strategically deploys funds across diverse asset classes.
- **Continuous Rebalancing**: Actively buys and sells assets to maintain portfolio balance according to predefined strategies.
- **Yield Optimization**: Identifies and allocates funds into high-yield opportunities such as Liquidity Provider (LP) Pools and Lending Markets.

###

Portfolio Agent Lifecycle

The Portfolio Agent operates as a trustless autonomous process running on the AO Network, initiated on behalf of the creator/user.

The typical lifecycle of a Portfolio Agent includes:

- **Creation & Funding** → Agent is initialized and funded by the user.
- **Continuous Optimization** → Agent autonomously manages assets through rebalancing and yield generation.
- **Termination & Withdrawal** → User can terminate the agent at any time, withdrawing all managed funds.

---

##

🛠️ Creating and Managing a Portfolio Agent on Dexi

###

🔗 Connecting Your Wallet & Navigating the Interface

First, connect your crypto wallet to Dexi. Once connected, navigate to the **My Portfolio** page. Here, you have a comprehensive overview of your portfolio:

- **Asset Overview**: Displays your held assets and their values.
- **Liquidity Pools (LPs)**: Lists active pools you're participating in.
- **Running Agents**: Shows all currently active autonomous agents you've spawned.
- **Transaction History**: Records all your past transactions.
- Other financial instruments on the AO network

  ![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252Fcs3RahDOYGOwruEhDiZL%252Fimage.png%3Falt%3Dmedia%26token%3D37d68961-acec-4ba4-b467-a500fce8d005&width=768&dpr=4&quality=100&sign=5154efd0&sv=2)

Consider this your command center—a centralized dashboard providing full visibility and control over your interactions within the AO ecosystem.

---

###

🚀 Spawning a Portfolio Agent

From the **My Portfolio** page, click on the clearly indicated **"Spawn Portfolio Agent"** button. This action will open a modal window allowing you to configure your new Portfolio Agent comprehensively.

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F5L18GXi9YtxHewEHudSv%252Fimage.png%3Falt%3Dmedia%26token%3D9a7614f5-1951-46ce-b0e8-2ba61e65cac3&width=768&dpr=4&quality=100&sign=42db9e28&sv=2)

####

⚙️ Configuring Your Portfolio Agent

When the configuration modal opens, you will be asked for several key inputs:

- **Agent Name**: Give your agent a unique, easily identifiable name.
- **Quote Token**: Currently, AO is the default quote token used to value your portfolio. You can also use AR or other Assets as the Quote assets.
- **Portfolio Tokens**: Select at least two tokens to include in your agent's portfolio.

Once tokens are selected, Dexi automatically populates the available tokens list, clearly displaying:

- **Token Name**
- **Current Price**
- **Available Liquidity**

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FRcgUhTMQMxFGfEbboPws%252Fimage.png%3Falt%3Dmedia%26token%3D1b6c615f-1a36-41f5-8c22-0e68c0562c03&width=768&dpr=4&quality=100&sign=2130cd47&sv=2)

Initially, your portfolio allocation will be evenly distributed across selected tokens. Adjust individual allocations by changing percentages, instantly reflected visually in an interactive pie chart.

As you modify the token percentages:

- The pie chart dynamically updates, clearly illustrating your portfolio's composition.
- Each token's allocation can be precisely adjusted, providing granular control over your asset exposure.

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F0EdPNm8P7XDVAXdrVyyB%252Fimage.png%3Falt%3Dmedia%26token%3D7bc5a678-301e-4dec-a834-229ef893dc34&width=768&dpr=4&quality=100&sign=659f39f&sv=2)

---

####

🎚️ Deviation Percentage Explained

The **Deviation Percentage** allows the Portfolio Agent to determine permissible fluctuations away from the target asset allocations during active management.

For example:

- A **10% deviation** means:

  - A portfolio with **4 assets** allows each asset to deviate by approximately **±2.5%**.
  - A portfolio with **10 assets** means each asset deviates roughly **±1%**.

This flexible mechanism helps minimize unnecessary trading costs while maintaining portfolio balance efficiently.

---

####

📌 Slippage Tolerance

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F9QSWzN9yQVNsY66LsDOw%252Fimage.png%3Falt%3Dmedia%26token%3D1b6abf6c-5c4d-4207-b7fd-c6b5d21ef8ce&width=768&dpr=4&quality=100&sign=b19e53ec&sv=2)

**Slippage Tolerance** defines the maximum acceptable price impact when your agent swaps tokens. This feature ensures your agent executes trades efficiently, balancing speed and cost-effectiveness.

- Dexi primarily supports Uniswap V2-type pools, meaning some price impact is inevitable.
- A **minimum of 5% slippage tolerance** is recommended, accommodating lower-liquidity pools effectively.
- When enabled, the agent always seeks the lowest possible price impact, ensuring optimal execution conditions for your portfolio.

---

####

💰 Funding & Spawning Your Agent

After configuring your asset selections, deviation, slippage tolerance, and reviewing your portfolio allocation:

1.  Enter the total **Investment Amount** in AO Tokens.
2.  Click **"Create"** to spawn your Portfolio Agent.

Upon creation, your funds are deployed, and the Portfolio Agent becomes an autonomous, active process within the AO ecosystem.

---

###

⚙️ Managing Your Portfolio Agent

After deployment, Dexi provides intuitive controls to actively manage your Portfolio Agent directly through the user-friendly agent interface.

####

🔹 Top-up, Pause, and Withdraw Actions

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FxzdsbTcU9PjFwAvdacXq%252Fimage.png%3Falt%3Dmedia%26token%3Db4f4d3e2-8aad-44ed-9d3b-f3e02c454780&width=768&dpr=4&quality=100&sign=14d217d4&sv=2)

Once your Portfolio Agent is active, you'll have convenient controls at your fingertips:

- **🔼 Top-up**

  - Allows you to add additional funds to an already running agent. Useful for scaling successful strategies or reacting proactively to market conditions.

- **⏸️ Pause**

  - Temporarily pauses your agent’s autonomous actions, halting all rebalancing and asset management activities. Ideal during volatile or uncertain market periods, letting you manually review conditions or strategies before resuming operations.

- **🔽 Withdraw**

  - Initiates the termination of your Portfolio Agent, prompting the withdrawal of all managed funds. A detailed summary screen appears, clearly displaying assets to withdraw, deposit history, and the agent’s lifetime performance metrics (PnL, duration, rebalance frequency).

####

📋 Agent Withdrawal Summary

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FDWaiCwtZyf8r6TYBybhR%252Fimage.png%3Falt%3Dmedia%26token%3D3c43f5d6-9943-41d4-ad46-1c3269c01248&width=768&dpr=4&quality=100&sign=716ef3c4&sv=2)

When withdrawing, Dexi provides a comprehensive summary:

- **Assets to Withdraw**: Clearly lists tokens and their current value.
- **Deposit History**: Displays the total funds you've deposited into the agent.
- **Performance Overview**: Summarizes the agent’s lifespan, number of rebalances, total deposited funds, and overall profit or loss, giving complete transparency on its effectiveness.

---

###

📈 Agent Interface Overview (Monitoring Your Agent)

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FNAXhgajFEqmwGlXQKsEX%252Fimage.png%3Falt%3Dmedia%26token%3D33504833-5e00-4773-a108-406cf067cb6c&width=768&dpr=4&quality=100&sign=b179d079&sv=2)

Clicking your newly spawned Portfolio Agent opens its detailed interface, designed to offer a clear, actionable overview of your agent’s ongoing activities.

- Displays agent name, type, ownership, and current net worth.
- Quick-action buttons such as "Clone Agent" and immediate controls for process management.
- **Agent Status Bar**:

  - Shows real-time status (**Balanced**, **Rebalancing**, or **Idle**).
  - Indicates current maximum imbalance and last rebalance activity.
  - Clearly specifies the quote token and slippage settings.

- **Allocation Charts**:

  - Visually compares target vs. current asset allocations.
  - Enables quick visual confirmation of portfolio balance.

- **Historical Networth Chart**:

  - Provides a dynamic visualization of your portfolio's value over time.
  - Interactive and informative, making tracking performance intuitive.

- **Overview Section**:

  - Detailed breakdown of all tokens managed by your agent, including current holdings, token prices, paper values, and realizable values.

- **Rebalance History**:

  - Chronological record of past rebalance actions.
  - Clearly highlights changes in asset positions with color-coded performance indicators, giving full transparency to the agent's decisions.

Last updated 5 months ago
