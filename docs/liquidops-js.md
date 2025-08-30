# LiquidOps JS Documentation

## Installation & Quickstart

You can install the LiquidOps JS using npm:

```
npm i liquidops
```

Or using yarn:

```
yarn add liquidops
```

Or using bun:

```
bun i liquidops
```

{% hint style="warning" %}

```
@permaweb/aoconnect >= 0.0.77
ao-tokens >= 0.0.6
warp-arbundles >= 1.0.4
```

Required peer dependencies for LiquidOps JS
{% endhint %}

Declare LiquidOps class in node environments:

```typescript
import { createDataItemSigner } from "@permaweb/aoconnect/dist/client/node/wallet";
import LiquidOps from "liquidops";

const JWK = `{
  "kty": "RSA",
  "e": "AQAB",
  "n": "...",
  "d": "...",
  "p": "...",
  "q": "...",
  "dp": "...",
  "dq": "...",
  "qi": "..."
}`;

const signer = createDataItemSigner(JWK);

const client = new LiquidOps(signer);
```

You can also add optional custom configurations to the SDK:

```typescript
const client = new LiquidOps(signer, {
  GATEWAY_URL: "",
  GRAPHQL_URL: "",
  GRAPHQL_MAX_RETRIES: "",
  GRAPHQL_RETRY_BACKOFF: "",
  MU_URL: "",
  CU_URL: "",
});
```

Declare LiquidOps class in web environments:

```typescript
import { createDataItemSigner } from "@permaweb/aoconnect/dist/client/node/wallet";
import LiquidOps from "liquidops";

const signer = createDataItemSigner(window.arweaveWallet);

const client = new LiquidOps(signer);
```

Here's a simple lending example to get you started:

```typescript
import { createDataItemSigner } from "@permaweb/aoconnect/dist/client/node/wallet";
import LiquidOps from "liquidops";

const signer = createDataItemSigner(window.arweaveWallet);

const client = new LiquidOps(signer);

const lend = await client.lend({
  token: "QAR",
  quantity: 1n,
});

console.log(lend);
```

## Lending

Lend tokens

```typescript
const lend = await client.lend({
  token: "QAR",
  quantity: 1n,
});
```

Un lend tokens

```typescript
const unLend = await client.unLend({
  token: "QAR",
  quantity: 1n,
});
```

## Borrowing

Borrow tokens

```typescript
const borrow = await client.borrow({
  token: "QAR",
  quantity: 1n,
});
```

Repay borrowed tokens

```typescript
const repay = await client.repay({
  token: "QAR",
  quantity: 1n,
});
```

## oToken Data Functions

Get APR for a token

```typescript
const getAPR = await client.getAPR({
  token: "QAR",
});
```

Get balances

```typescript
const getBalances = await client.getBalances({
  token: "QAR",
});
```

Get exchange rate

```typescript
const getExchangeRate = await client.getExchangeRate({
  token: "QAR",
});
```

Get global position

```typescript
const getGlobalPosition = await client.getGlobalPosition({
  walletAddress: "psh5nUh3VF22Pr8LeoV1K2blRNOOnoVH0BbZ85yRick",
});
```

Get token info

```typescript
const getInfo = await client.getInfo({
  token: "QAR",
});
```

Get position for a address

```typescript
const getPosition = await client.getPosition({
  token: "QAR",
  recipient: "psh5nUh3VF22Pr8LeoV1K2blRNOOnoVH0BbZ85yRick",
});
```

## Protocol Data Functions

Get all positions

```typescript
const getAllPositions = await client.getAllPositions({
  token: "QAR",
});
```

Get historical APR

```typescript
const getHistoricalAPR = await client.getHistoricalAPR({
  token: "QAR",
});
```

## Retrieving Transactions

Get transactions for a specific token and action

```typescript
const getTransactions = await client.getTransactions({
  token: "QAR",
  action: "lend", // "lend" | "unLend" | "borrow" | "repay";
  walletAddress: "psh5nUh3VF22Pr8LeoV1K2blRNOOnoVH0BbZ85yRick",
});
```

Get a transactions result after it has been submitted

```typescript
const getResult = await LiquidOpsClient.getResult({
    transferID "", // the id returned from lend/borrow/unLend/repay
    tokenAddress: '', // address of the token
    action: "", // "lend" | "unLend" | "borrow" | "repay";
});
```

## Token Data

Access supported token data

```typescript
import { tokenData, tokens, oTokens, controllers } from "liquidops";
```

Get token details

```typescript
const qarData = tokenData.QAR;
/* {
    name: "Quantum Arweave",
    ticker: "QAR", 
    address: "XJYGT9...",
    oTicker: "oQAR",
    oAddress: "CbT2b...",
    controllerAddress: "vYlv6...",
    // ...other metadata
} */
```

Get base token addresses

```typescript
const tokenAddress = tokens.QAR; // "XJYGT9..."
```

Get oToken addresses

```typescript
const oTokenAddress = oTokens.oQAR; // "CbT2b..."
```

Get controller addresses

```typescript
const controllerAddress = controllers.QAR; // "vYlv6..."
```

Helper function to resolve token addresses and related data

```typescript
import { tokenInput, type TokenInput } from "liquidops";
```

Can use either ticker or address

```typescript
const resolved = tokenInput("QAR");
```

Or

```typescript
const resolved = tokenInput("XJYGT9ZrVdzQ5d7FzptIsKrJtEF4jWPbgC91bXuBAwU");

/* Returns:
{
  tokenAddress: "XJYGT9...",    // Base token address
  oTokenAddress: "CbT2b...",    // oToken address
  controllerAddress: "vYlv6..." // Controller process address
}
*/
```

Currently supported tokens: QAR (Test Quantum Arweave) and USDC (Test USD Circle)

## Utility Functions

Get balance

```typescript
const getBalance = await client.getBalance({
  tokenAddress: "XJYGT9ZrVdzQ5d7FzptIsKrJtEF4jWPbgC91bXuBAwU",
  walletAddress: "psh5nUh3VF22Pr8LeoV1K2blRNOOnoVH0BbZ85yRick",
});
```

Get price

```typescript
const getPrice = await client.getPrice({
  token: "WAR",
});
```

Get result

```typescript
const getResult = await client.getResult({
  transferID: "0RY-eSVV156qxyuHBs3GPO2pwsIvmA-yI1oKS1ABSyI",
  tokenAddress: "XJYGT9ZrVdzQ5d7FzptIsKrJtEF4jWPbgC91bXuBAwU",
  action: "lend", // "lend" | "unLend" | "borrow" | "repay";
});
```

Transfer tokens

```typescript
const transfer = await client.transfer({
  token: "QAR",
  recipient: "psh5nUh3VF22Pr8LeoV1K2blRNOOnoVH0BbZ85yRick",
  quantity: 1n,
});
```