All advanced order types on Botega are actually powered by Autonomous Agents. These are independent processes created specifically for the user, designed to interact with various systems such as oracles, liquidity pools, and more. These agents carry advanced logic, enabling features like trailing stops, risk assessments, and other sophisticated trading strategies.

###

Stop Loss Orders on Botega

Stop Loss orders are a powerful risk management tool that allows you to automatically sell your tokens when certain market conditions are met. On Botega, there are **three types** of Stop Loss orders:

1.  **Market Stop Loss**
2.  **Limit Stop Loss**
3.  **Trailing Stop Loss**

Each type has its own unique characteristics, offering different levels of control and flexibility to traders. Below, we'll walk through how to use each Stop Loss order type and highlight the advantages and disadvantages of each.

---

####

1\. **Market Stop Loss**

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FkvOoP6DOi2RDIg7i8TXp%252Fstoploss-market.gif%3Falt%3Dmedia%26token%3D69773626-d532-47bf-a67e-1b02458066b7&width=768&dpr=4&quality=100&sign=cc1ccdff&sv=2)

A **Market Stop Loss** executes a trade as soon as the trigger price is reached, selling your tokens at the best available market price. This order type guarantees execution but not the price at which the trade will occur.

**How to Use:**

1.  **Select "Market"** under the Stop Loss tab.
2.  **Choose Your Tokens**:

    - **You Sell**: Select the token you wish to sell.
    - **You Buy**: Choose the token you want to receive.

3.  **Set Stop Loss Trigger Price**:

    - Input the price at which your Stop Loss will trigger. You can also use percentage adjustments (Market, -5%, -10%, etc.) to quickly set the trigger price.

4.  **Review & Start**:

    - Once you're satisfied with the settings, click **Start Stop Loss Agent**.

**Advantages:**

- **Guaranteed Execution**: The trade will always be executed once the trigger price is hit.
- **Simple Setup**: No need to set additional parameters beyond the trigger price.

**Disadvantages:**

- **Price Uncertainty**: The trade will be executed at the market price, which could fluctuate rapidly.

---

####

2\. **Limit Stop Loss**

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FSrFOCablPPMG16FbTLQO%252Fstoploss-limit.gif%3Falt%3Dmedia%26token%3Dac7243b3-5fde-4141-8ded-704299879390&width=768&dpr=4&quality=100&sign=69c4ba20&sv=2)

A **Limit Stop Loss** adds more control by allowing you to set both a **trigger price** and a **limit price**. When the trigger price is reached, the agent will only execute the trade if the market price matches or is better than the limit price.

**How to Use:**

1.  **Select "Limit"** under the Stop Loss tab.
2.  **Choose Your Tokens**:

    - **You Sell**: Select the token you wish to sell.
    - **You Buy**: Choose the token you want to receive.

3.  **Set Stop Loss Trigger Price**:

    - Input the price at which the Stop Loss will trigger.

4.  **Set Limit Price**:

    - Enter the limit price, which is the lowest price you are willing to accept when the Stop Loss is triggered.

5.  **Review & Start**:

    - Review the settings and click **Start Stop Loss Agent**.

**Advantages:**

- **More Control**: You can specify both the trigger and limit prices, ensuring that the trade only happens at a desirable price.
- **Risk Management**: Reduces the risk of selling at a very low market price during sudden price drops.

**Disadvantages:**

- **No Execution Guarantee**: If the market price does not reach your limit price after the trigger, the trade may not be executed.

---

####

3\. **Trailing Stop Loss**

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FvVGqUJmOfkGqorOamzrM%252Fstoploss-trail.gif%3Falt%3Dmedia%26token%3Dd0fae315-d2bd-46ae-b8c5-e023cd4e3334&width=768&dpr=4&quality=100&sign=1d4602b4&sv=2)

A **Trailing Stop Loss** dynamically adjusts the trigger price as the market moves in your favor. The stop price "trails" the market price by a set percentage. This ensures that you lock in profits as the market rises, but automatically sell if the price drops by the trailing percentage.

**How to Use:**

1.  **Select "Trailing"** under the Stop Loss tab.
2.  **Choose Your Tokens**:

    - **You Sell**: Select the token you wish to sell.
    - **You Buy**: Choose the token you want to receive.

3.  **Set Trailing Percentage**:

    - Input the trailing percentage that will adjust the stop price relative to the current market price.

4.  **Review & Start**:

    - Once you're satisfied with the settings, click **Start Stop Loss Agent**.

**Advantages:**

- **Profit Maximization**: The trailing stop adjusts upward with the market, allowing you to capture gains while limiting downside risks.
- **Automated Risk Management**: Once set, the trailing stop automatically follows the market, requiring no further action.

**Disadvantages:**

- **No Price Guarantee**: Like a Market Stop Loss, the execution price may fluctuate, and you may not get the exact stop price you set.

---

####

Summary of Pros and Cons:

More control over execution price

No guarantee of execution

Captures market upside automatically

Price fluctuation risk upon execution

Last updated 2 months ago
