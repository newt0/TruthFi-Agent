Subscribe to Dexi data agents to receive continuous data updates and configure sophisticated financial applications.

##

How to Subscribe to Dexi Data Agents

To subscribe to a Data Agent in Dexi, you need to register your process with the Dexi agent and deposit a fee that will be used to cover the transaction costs.

**Note:** The AO Network is currently in the testnet phase, so there are no actual transaction costs. This allows developers to freely determine their own cost structure if they wish to apply this pattern. Dexi requires a minimum of 1 AOCRED per process.

###

Subscription Tiers

Dexi currently offers two service tiers.

###

Free

- **Pull-based access**: Users can request data as needed.
- **Dry runs (read-only)**: Allows users to simulate transactions without actual execution.
- **Web UI**: Accessible terminal for casual browsing and data exploration.
- **Basic trading data**: Essential data for simple trade analysis.

###

Paid

- **Push-based (subscriptions)**: Data is automatically delivered based on specified criteria.
- **Periodic / Event-based**: Updates are sent at regular intervals or triggered by specific events.

Users can register an agent with Dexi by sending the following specific message format, which will add an entry to the subscriptions database:

```html
Send({ Target = 'POJ5oyOzEnQf3Gm7yxVFOmWV5I-LfpAxIw_dYH1Kl-Y', Action =
'Register-Process', ['AMM-Process-Id'] =
'U3Yy3MQ41urYMvSmzHsaA4hJEDuvIm-TgXvSm-wz-X0', ['Subscriber-Process-Id'] =
<Process that should receive Signals
  >, ['Owner-Id'] = <Subscriber Owner> })</Subscriber></Process
>
```

This structured setup ensures that developers and users can easily engage with Dexi’s services, utilizing the network’s capabilities for both basic and advanced data needs.

##

Payment Model

Dexi's payment model demonstrates AO's flexibility. Read-only offchain requests are handled by subsidized Computer Units (CUs), serving non-commercial users who browse information for potential purchases. These nodes can be locally operated, allowing anyone to independently verify results.

For onchain financial agents that require enhanced economic security due to immediate actions based on Dexi's signals, the model differs. Trigger dispatches operate on the AO Mainnet, secured by its full economic safeguards. This service incurs gas costs, which are covered by a subscription fee.

Financial agent operators select the data subscriptions they need and receive an estimate of the gas expenses plus Dexi fees for a specified period. Once the payment is completed, the owner registers their bots with Dexi to periodically receive the necessary data.

###

Funding

Before Dexi can dispatch messages, users must fund their accounts for the specific process they are utilizing.

##

Cron Messages

Dexi runs on a cron schedule, receiving a tick every minute. Currently, it sends signals on an hourly basis by checking the cron message's timestamp to detect the start of a new hour. At the beginning of each hour, Dexi performs the following actions:

1.  Scans through all registered AMMs.
2.  Confirms that all subscribers are adequately funded.
3.  Calculates the necessary indicators.
4.  Sends out the relevant messages.

Last updated 10 months ago
