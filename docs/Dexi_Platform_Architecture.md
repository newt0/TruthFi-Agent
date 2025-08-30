![](https://docs.autonomous.finance/~gitbook/image?url=https%3A%2F%2F299217142-files.gitbook.io%2F%7E%2Ffiles%2Fv0%2Fb%2Fgitbook-x-prod.appspot.com%2Fo%2Fspaces%252Fqi2z6qbW0AckrNyiYMEk%252Fuploads%252FifyhrFg6wA3GLFcuqPLJ%252Fimage.png%3Falt%3Dmedia%26token%3Da55848d0-eb52-42c2-ae22-063a2f344c2d&width=768&dpr=4&quality=100&sign=2cf10b43&sv=2)

##

Role in the AO Ecosystem

###

Introduction

Autonomous agents represent a significant leap in decentralized technology, acting as self-sustaining entities that can make independent decisions based on real-time data. In the AO ecosystem, these agents are empowered to manage assets, optimize trades, and perform risk assessments without constant human oversight. Dexi serves as a crucial hub within this ecosystem, providing the infrastructure necessary for these agents to access data, liquidity, and trust mechanisms.

###

Dexi: The Hub for Autonomous Agents

Dexi’s primary objective is to create an all-encompassing platform for autonomous agents within the AO ecosystem. It connects agents to the resources they need, offering easy access to crucial data, liquidity, and trust mechanisms. By serving as the central hub, Dexi simplifies complex operations and ensures that agents can thrive and operate efficiently.

- One-stop platform for autonomous agents within AO
- Connecting agents with essential infrastructure and data
- Dexi’s place in the broader AO ecosystem

###

Core Requirements for Autonomous Agents

To function optimally, autonomous agents require a set of key resources: data, capital, liquidity, and trust. These components allow agents to make informed decisions, access the liquidity needed for operations, and build trust between creators and participants in the ecosystem. Dexi plays a vital role in providing these core necessities.

####

Data Access: On-Chain and Off-Chain Signals

Agents rely heavily on real-time data to make informed decisions. This data comes from both on-chain sources, like blockchain transactions, and off-chain sources, like market trends and external events. Dexi aggregates this data and delivers it in a format that autonomous agents can easily use.

####

Accessing Capital and Liquidity

Autonomous agents also need liquidity to function effectively. Dexi simplifies this by offering access to capital via various sources, such as liquidity bootstrapping from participants or settlement engines like Botega and LiquidOps.

- Agents need capital to function
- Liquidity bootstrapping through participants and settlement engines (Botega, LiquidOps)
- Dexi’s role in providing seamless access to liquidity

###

Trust Layers in the Agent Economy

Autonomous agents operate in a decentralized environment where trust is essential. Dexi acts as a trust layer between agents, asset settlements, creators, and participants. It ensures that agents can be trusted to handle asset settlements correctly and helps connect agent creators with participants who can pool resources and support the agent’s activities.

####

Ensuring Trust Between Agents and Asset Settlement

Dexi ensures that agents operate transparently and manage assets correctly. This trust layer is vital for smooth asset settlement and trade execution.

- Trust as a critical component for agent operations
- Dexi as a mediator between agents and asset settlements

####

Trust Between Agent Creators and Participants

For agents to function, trust must also exist between the creators and those who fund or support the agents. Dexi facilitates this by acting as a platform for pooling funds and ensuring fair distribution, building trust in the process.

- Dexi as a platform for trust between creators and participants
- Pooling funds into agents and ensuring fair distribution

###

Real-Time Market Data for Agents

Effective decision-making requires up-to-date market data, which is where Dexi excels. By providing real-time price feeds and market information, Dexi enables agents to create and adjust risk management strategies dynamically. These real-time feeds act like oracles, offering a dependable source of market information that agents can rely on.

- Providing real-time price data for risk management
- Dexi as a source of oracle-like price feeds for agents and exchanges
- Importance of market data for agent decision-making

###

Incentive Structures and Liquidity Pools

Dexi plays a significant role in dynamically adjusting incentive structures for liquidity pools. By supplying the necessary data, agents can optimize swaps, ensure liquidity, and adjust incentives in real time to meet the demands of a changing market.

- Adjusting incentives for liquidity pools
- Using data to optimize swaps and liquidity management
- Dexi’s role in providing real-time insights for incentive adjustments

###

On-Chain Data for Strategic Decision-Making

Autonomous agents can tap into more sophisticated decision-making processes by leveraging on-chain data, which is analyzed by Large Language Models (LLMs). Dexi provides the data that these LLMs need to continuously enhance strategic decisions, making agents smarter over time.

- Supplying on-chain data to LLMs
- Enhancing agent decision-making with AI insights
- Dexi’s role in improving strategic decisions for agents through continuous data delivery

---

##

Technical Architecture

Dexi is composed of a network of autonomous agents that coordinate to manage platform tasks. Unlike traditional blockchain networks, AO can run deterministic WASM code, improving scalability by avoiding a shared global state. Dexi leverages this capability with the AOS SQLite module, a WASM version of SQLite, enabling on chain functionalities such as aggregations, triggers, and complex queries.

Additionally, Dexi supports features often associated with off chain Web2 applications, but with key differences. Dexi is fully on chain, maintained by AO processes, and securely stores data on Arweave. This provides several advantages:

- Information displayed on the Dexi terminal cannot be manipulated or censored by third parties, unlike on traditional Web2 networks.
- All data aggregated and displayed on the Dexi terminal is verifiable on chain.
- Enables advanced data processing directly on the blockchain, essential for building sophisticated financial applications.

Last updated 10 months ago
