![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FlOWiauQseevz9BA2U4u6%252Fimage.png%3Falt%3Dmedia%26token%3D420c55a4-c048-4c94-929c-54f213f121dc&width=768&dpr=4&quality=100&sign=664a93e8&sv=2)

It provides a visual interface for adjusting parameters like market cap, supply, and fees. The generated bonding curve is also capable of automated liquidity migration to the Botega DEX once a certain market cap target is reached. This document outlines how the page works, how to configure your curve, and how the generated Lua code can be used.

###

1\. Overview

A **bonding curve** is a mathematical pricing tool where the token’s price is defined as a function of supply. In this particular implementation, we use a power function:

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F2ATKEMldjwbi8dFFkzeq%252Fimage.png%3Falt%3Dmedia%26token%3D9be40efd-d447-4ff9-bd79-8f07fa53654d&width=768&dpr=4&quality=100&sign=9f62e2be&sv=2)

where:

- `*s*` is the current circulating supply of your token,
- `*m*` and `*n*` are constants derived from your chosen **Reserve Ratio (RR)** and the target supply/market cap configuration.

This page helps you create a bonding curve process on AO which acts as a **distribution mechanism for your token of choice**, once it is initialized by receiving that token's supply.

Users will be able to buy and sell the issued token by using the bonding curve as a counterparty. The default quote token for these trades should be a base high liquidity asset like wrapped AR, AO or a Stablecoin. In our example we are using qAR. TokenId:

> qAR: NG-0lVX882MG5nhARrSzyprEK6ejonHpdUmaaMPsHE8 wAR: xU9zFkq3X2ZQ6olwNVvr1vUWIjc3kXTWr7xKQD6dh10

The bonding curve is configured with a **target**, meaning that once a certain market cap / supply is reached, it stops acting as a trading counterparty. Instead, it **migrates liquidity** to Botega, while pairing the accumulated `wAR` reserve with an equivalent amount of the curve token that was not yet issued.

In order for this page to generate lua code for your bonding curve, you can:

- Configure the bonding curve parameters (target supply, target market cap, reserve ratio, etc.).
- Preview how the price changes as the token supply grows.

Once the code is generated you are free to extend or change it according to your needs before loading it into a new AO process.

###

2\. Bonding Curve Configuration

####

2.1. Core Inputs

You can customize the following inputs through the interface:

1.  **Target Market Cap**: The total market cap (in `qAR`) at which the bonding curve will migrate to Botega.
2.  **Target Supply**: The total number of tokens (`xCOIN`, representing your custom token) that you want distributed by the time you reach the target.
3.  **Reserve Ratio (RR)**: A few options in the interval \[`0.15` .. `0.5`\].

    - **Lower RR**: Steeper price increases after initial supply. More volatility and higher potential upside for early buyers.
    - **Higher RR**: Smoother, more gradual price curve. Less volatility but potentially lower upside.

4.  **Transaction Fee (in %)**: A percentage fee imposed on each buy or sell, collected in `qAR`.
5.  **Developer Account**: The AO account to which all fees are transferred, as well as unburned LP tokens after the Botega migration.
6.  **Token to be Distributed (Process ID)**: The token you want to distribute via this bonding curve (referred to as `xCOIN` in the UI, but you can provide any AO process ID and matching custom ticker).
7.  **Token Ticker and Denomination**: Your custom token ticker and the denomination. The default of `18` is recommended
8.  **LP Tokens Burn Ratio**: Upon migrating liquidity to Botega, the AMM returns LP tokens. A certain percentage can be burned, with the remainder transferred to your developer account.

####

2.2. Derived Configuration

From these inputs, the UI calculates:

1.  **Target Liquidity (qAR)**: The total `qAR` to be accumulated by the curve once the target is reached.
2.  **Target Price (in qAR)**: The spot price of one unit of your token at the target supply and market cap.

These values are automatically updated and displayed in the form.

1.  **Curve exponent (n)**: The exponent of the power function that the curve is based on.

The curve exponent `n` is not displayed in the UI, but set in the bonding curve code behind the scenes, based on `RR`

1.  **Scaling constant (m)**: The scaling constant of the power function that the curve is based on.

The scaling constant `m` is also not displayed in the UI, but set in the bonding curve code behind the scenes, based on the relationship between target price and target supply.

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FtAQ6igiewjVk35kC6u4J%252Fimage.png%3Falt%3Dmedia%26token%3D87e7156b-f9cf-40fe-b5ac-05759f3bea95&width=768&dpr=4&quality=100&sign=25c2e69e&sv=2)

####

2.3 Reserve Ratio vs. Curve Exponent

`RR` is defined as the ratio between curve reserve balance (accumulated liquidity) and market cap (distributed value, expressed in the currency of the accumulated liquidity). It represents an **invariant of the bonding curve**.

With the bonding curve being based on the power function

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FCFdpZ0jiZ5o91S7ROVcg%252Fimage.png%3Falt%3Dmedia%26token%3D1d304af0-5532-4ae8-9d2d-42a06634617e&width=768&dpr=4&quality=100&sign=f53054ba&sv=2)

We chose to **make** `**RR**` **adjustable in the UI**, and derive `n` from there, due to the expressive nature of `RR`: it defines the curve shape and moves within the interval `[0,1]`. In our particular set of limitations, we restrict it even more, so that `RR` is in the interval `[0.15, 0.5]`.

By tweaking `RR` instead of `n`, a curve builder can better grasp the impact of the configuration on the curve mechanism.

**Deriving** `**n**` **from** `**RR**`

The handy relationship that expresses `n` based on `RR` can be obtained starting with the definition for `RR` and by expressing everything (accumulated liquidity and market cap) in terms of the supply at any particular moment.

The accumulated liquidity is in direct relation to the distributed supply, due to the curve formula. If we integrate the curve formula over the interval from `0` to a given supply `s`, we obtain the required liquidity in order to get to `s`.

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FDyg9ijAbJhe2cZLks285%252Fimage.png%3Falt%3Dmedia%26token%3D6df32794-21cf-4693-b628-7580873b1596&width=768&dpr=4&quality=100&sign=a6f10c75&sv=2)

###

3\. Visual Preview & Life Cycle

The **Preview** section plots a graph of the token price against the supply according to the chosen power function. Two notable points are annotated:

- **First Buy**: Illustrates an example of purchasing 1 `qAR` worth of tokens (minus fees) from the curve at the earliest supply.
- **Target**: The configured supply (and corresponding price) at which the curve will migrate to Botega.

In addition, the **Bonding Curve Life Cycle** is broken down into three stages:

1.  **Configure & Deploy**
2.  **Active Buy & Sell Phase**
3.  **Liquidity Migration to Botega DEX**

Once the target is reached, all accumulated reserve (`qAR`) is paired with any remaining undistributed tokens to form liquidity on Botega.

###

4\. Form Field Descriptions

Each form field in the **Create Bonding Curve Form** corresponds to your bonding curve’s configuration.

1.  **Target Market Cap (qAR)**
2.  **Target Supply (xCOIN)**
3.  **Reserve Ratio (RR)**
4.  **Transaction Fees (%)**
5.  **Curve Token Process** (the AO process ID of your custom token)
6.  **Curve Token Ticker** (a short uppercase identifier, e.g. `MYT`)
7.  **Curve Token Denomination** (default and recommended: 18)
8.  **Developer Account** (your AO account ID)
9.  **LP Tokens Burn Ratio (%)**

Many fields have tooltips that appear as question-mark icons, providing deeper explanations and hints for best practices.

###

5\. Generating Lua Code

After finalizing your settings, click **Generate Code** to produce a Lua script that can be deployed on the AO platform. The code:

- Exposes a minimal set of message handlers for **buying** and **selling** tokens, as well as `Info` for querying the configuration and state of your bonding curve.
- Manages an internal state of how many tokens have been issued, how many remain for distribution, and how much wAR has been accumulated.
- Automatically triggers liquidity migration to Botega DEX when the target is reached.

You can copy the generated Lua code and load it into a new AO process. In the UI, the code is shown in a syntax-highlighted window with a **Copy** button.

####

Refinement

You can of course extend and refine the bonding curve functionality. The code is commented on multiple levels, giving you guidance in understanding how it works and why it is built like this.

⚠️ The code is tested to work with all configurations allowed by the UI. If you want to use other values, e.g. a reserve ratio `RR > 0.5` or a target supply `> 1 Million`, make sure that you understand the implications regarding the integer arithmetic required for these

###

6\. Integration Instructions

####

6.1. Initializing the Bonding Curve

1.  **Create or Identify Your Token**

    - Before using this bonding curve, you must have a token process (with sufficient total supply) on AO.
    - The token should generally use 18 decimal places to ensure reliable calculations.

📝 Recommended workflow:

> - create a new token process and mint 1 Billion tokens (1,000,000,000 \* 10^18)
> - transfer all tokens to the bonding curve in the initialization step (see handlers)
>
> This will **ensure the required supply for the complete bonding curve life cycle**, regardless of your curve configuration, as long as you stay in the ranges available in the configuration UI. All excess (unissued) tokens after the Botega migration will be burned by the curve

1.  **Deploy the Lua Code on AO**

    - Use the generated boilerplate script.
    - Load it into a new process via the `aos` CLI or another deployment method of your choice.
    - Confirm the successful deployment with a dry-run on the `Info` handler

2.  **Send Your Token to the Bonding Curve**

    - The bonding curve expects to be initialized by receiving all the tokens it will ever distribute. Remember to set the `["X-Action"] = "Initialize"` tag when you make the transfer
    - Confirm the successful initialization with a dry-run on the `Info` handler: check that `["Is-Initialized"] == "true"`

####

6.2. Operational Flow

- **Buying**: Users send `AR` (the reserve token) to the bonding curve process with the `X-Action` = `"Curve-Buy"`.

  - The bonding curve deducts fees, calculates how many tokens to issue based on its power function, and transfers tokens back to the buyer.

- **Selling**: Users send your distributed token back to the bonding curve with `X-Action` = `"Curve-Sell"`.

  - The curve calculates how much `AR` to return to the seller, deducts fees, and finalizes the transaction.

####

6.3. Liquidity Migration to Botega DEX

- Once the **Target Market Cap** is reached (i.e., the curve has accumulated the target amount of `AR`), the code sets `IsMigrating = true` and triggers migration.
- The bonding curve automatically creates a **Botega AMM** and provides liquidity:

  - All `AR` in the curve’s reserve is paired with an appropriate amount of undistributed tokens.
  - LP tokens are returned to the curve, and a portion (per your configuration) is burned (`LP_Tokens_Burn_Ratio`).
  - The remainder of the LP tokens is sent to your developer account.

> ⚠️ Please verify that you are using the latest Botega AMM factory process which can be found [here](https://af-registry.vercel.app/) (❗️ select "Production" from the radio button)

**Consistent Pricing on Migration**

The procedure for liquidity migration ensures that the initial marginal price of the AMM is the same as the price of the curve at the moment of migration (`Target-Curve-Price` in the `Info` response).

In this context, the marginal price of the AMM is **agnostic of denominations**. It simply divides the AMM reserve of q`AR` by the reserve of `xCOIN`.

The curve price (`Curve-Price`, `Target-Curve-Price` in the `Info` response) is also denomination agnostic, and it includes a scaling of `10 ^ 18` for precision.

**Example** A `Curve-Price` of `1,000,000` indicates that:

- One unit of `xCOIN` has a marginal value of `1,000,000 × 10^{-18}` units of `qAR`.
- Equivalently, one unit of `xCOIN` has a marginal value of `10^{-12}` units of `qAR`.
- This implies that a minimum of `10^{12}` units of `xCOIN` is required to obtain one unit of `qAR`.

In the context of an exchange, it is essential to account for token denominations:

- For `xCOIN` with a denomination of `18`, one `xCOIN` corresponds to `10^{18}` units.
- For `qAR` with a denomination of `12`, one `qAR` corresponds to `10^{12}` units.
- Given these denominations, `10^{12}` units of `xCOIN` equates to one unit of `qAR`.

This equivalence can be further expressed as:

- `10^{-6} xCOIN` corresponds to `10^{-18} qAR`.
- Therefore, `1 xCOIN` is equivalent to `10^{-12} qAR`.
- Alternatively, `1 xCOIN` is equal to `0.000000000001 qAR`.

---

###

7\. Technical Highlights

####

7.1. Integer Arithmetic for Power Function

Because AO’s Lua environment handles large integers via `.bint`, this bonding curve uses integer-only math to maintain precision for operations such as:

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FvkFDtGXvon6cNKqnvZxH%252Fimage.png%3Falt%3Dmedia%26token%3Df8d5be47-54f5-43c0-9a9d-1dab21a64c8d&width=768&dpr=4&quality=100&sign=ece0fab2&sv=2)

where:

- `cost` is how much `qAR` needs to be paid in order to have a supply of `s` distributed
- `price` is the continuous price after a supply of `s` has been distributed

Floating-point errors are minimized by converting values into “bints” with a suitably large exponent before exponentiation or division.

####

7.2. Newton’s Method for nth Root

To invert the power function (e.g., finding supply from a given cost), we need to compute the **n-th root** on large integers. We implement an integer-based [Newton’s method](https://en.wikipedia.org/wiki/Newton%27s_method) to converge on the correct root:

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F8jPLcQVuVQoHZgdVmp26%252Fimage.png%3Falt%3Dmedia%26token%3D63d274bd-2f95-436d-9088-f38996b75d55&width=768&dpr=4&quality=100&sign=877b6e91&sv=2)

Repeated iterations ensure we approximate the integer root without floating-point operations.

####

7.3 Heuristics for raising to a fractional power

In the curve calculations there is a need to perform power calculations where the base is an integer and the exponent is a fractional number.

In these cases we can perform the power operation as a combination of regular integer exponentiation and nth root based on Newton's method.

![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252F3KClS43ktu0fgi15Xpsl%252Fimage.png%3Falt%3Dmedia%26token%3D540e91a7-c0cd-4c86-8355-495aac9ec9ba&width=768&dpr=4&quality=100&sign=5625b0eb&sv=2)

In order to use this, we convert the fractional exponent into a (numerator, denominator) tuple. These fractional exponents are all derived from `RR`. Due to our **UI-imposed limitations** on `RR` (\[0.15, 0.2, 0.25, … , 0.5\]), we can use heuristics to choose the smallest possible values for numerator and denominator, such as to limit the computational load.

> e.g.
>
> ```html
> 0.35 = 7 / 20 0.35 ^ (-1) = 20 / 7 0.3 = 3 / 10 0.15 = 3 / 20 ... etc.
> ```

###

8\. Code References

The boilerplate contains:

- **Handlers** for `Info`, `Buy`, `Sell`, `Get-Buy-Output`, `Get-Sell-Output`, and the final Botega migration.
- **Integer-based calculations** to maintain consistency when computing cost, price, and supply.
- **Configuration placeholders** (like `###TARGET_MARKET_CAP###`, `###TARGET_SUPPLY###`, etc.) that are replaced by the form inputs.

---

###

9\. Limitations & Best Practices

- **Denomination**: For safest results, use the default 18 decimals for your distributed token (like standard ERC-20).
- **Initialization**: The curve only works after it is initialized with a transfer of tokens to be distributed. Ideally, send enough tokens to cover its entire life cycle.
- **Event Tracking**: The sample code does not store or emit advanced event logs for each buy/sell. If detailed tracking is needed, you can extend the script.
- **Timing**: Once the target is reached, no further buys or sells are processed; the code immediately proceeds with the migration.

---

###

10\. Further Notes

- While the UI references `xCOIN` as a sample ticker, you can freely change it to the ticker (and process ID) of your actual AO token.
- If you modify the **quote token** (default is `qAR`), ensure the script’s placeholders are adapted accordingly.
- The provided **life cycle** is an optional explanation for end users or integrators but reflects the recommended best practices for a full “Configure, Trade, Migrate” approach.
