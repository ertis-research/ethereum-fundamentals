# Ethereum Fundamentals
In this guide you will learn how to write, compile and deploy a smart contract into Ethereum mainnet or any of its testnets.

## Smart Contracts
A smart contract is a collection of code and data that resides at a specific address on the Ethereum blockchain network. Smart contracts are also a specific type of Ethereum account (they have balance and they can send transactions). However, they're not controlled by a user: they are deployed to the blockchain network and run as programmed. Users (with their Ethereum accounts) can interact with smart contracts by submitting transactions that execute functions defined on those smart contracts.

To deploy a contract to a Ethereum blockchain network it is necessary (apart from writting the contract itself) to have enought ether (ETH) on your account to carry out this operation. Deploying a smart contract is also a transaction, like a simple ETH transfer, so you will need to pay an amount of gas for contract deployment. There are two main programming languages for writting smart contracts: Solidity (similar to JavaScript) and Vyper (similar to Python). In this guide we will focus on smart contract programming using Solidity.

### Solidity
Solidity is an object-oriented, high-level language for implementing smart contracts. It has being designed to target the Ethereum Virtual Machine (EVM), is statically typed, supports inheritance, libraries and complex user-defined types (among other features). After writing a smart contract and before deploy it to a blockchain network, it is mandatory to compile that contract. There are multiple ways to install/use Solidity compiler: npm, Docker, Linux packages, macOs packages, binaries or building from source. I recommend using `npm / Node.js Solidity compiler` because it is the easiest alternative. To install it execute `npm install -g solc` on your favourite terminal. After installation verify using `solcjs --version`.

In order to present Solidity main features, directory [examples](./examples) includes a series of smart contracts that use some of those characteristics.

### Ethereum Virtual Machine (EVM)
The Ethereum Virtual Machine or EVM is the runtime environment for smart contracts in Ethereum. It is completely isolated, which means that code running inside the EVM has no access to network, filesystem or other processes. Smart contracts even have limited access to other smart contracts. EVM key points will be exposed down below:
* ___Accounts___. There are two types of accounts in Ethereum: __external__ and __contract__. The former type is controlled by public-private pair (i.e. humans), while the latter is controlled by the code stored together with the account. Both kinds of account are treated equally by the EVM. Furthermore, every account has a __balance__ in Ether (exactly in Wei, where `1 ether = 10^18 wei`) which can be modified by sending transactions including Ether.
* ___Transactions___. A transaction is a message that is sent from one account to another and it can include binary data (called payload) and Ether. If the target account is a contract account, its code is executed and the payload is provided as input data. If the target account is not set, the transaction creates a __new contract__.
* ___Gas___. When creating a transaction, this one is charged with a certain amount of __gas__. Gas purpose is to limit the amount of work that is needed to execute the transaction and to pay for this execution at the same. Moreover, the __gas price__ is set by the creator of the transaction, who will have to pay `gas_price * gas` up front from the sending account. If some gas is left after execution, it will be refunded to the transaction creator.
* ___Storage, memory and the stack___. The EVM has three areas where it can store data:
  * __Storage__. This area is persistent between functions calls and transactions. Furthemore, it is the most expensive area (talking in terms of gas consumption) since it is costly to read, and even more to initialise and modify. Because of this cost, it is highly recommended to minimise saving data in persistence storage.
  * __Memory__. The second area is freshly cleared for each message call. It is not a persistent area and is more costly the larger it grows (at the time of expansion, the cost in gas must be paid).
  * __The stack__. The EVM is not a register machine but a stack machine, so all computations are performed on a data area called the stack.

## Development environments

### Remix
For newcomers it is highly recommended to start programming Solidity through [Remix](#some-links). Remix IDE is an open source web and desktop application. It allows a fast development cycle and has a rich set of plugins with intuitive GUIs. Remix is used for the entire journey of smart contract development as well as being a playground for learning and teaching Ethereum. It includes editor, compiler and debugger (among other features) in one single site/app. 

Work in progress...

### Ganache
Work in progress...

## Web3
Work in progress...

## Deploying in testnets

### Infura
Work in progress...

### Faucets
Work in progress...

## Deploying in the mainnet
Work in progress...

### Some Links
[Solidity Documentation](https://docs.soliditylang.org/)

[Vyper Documentation](https://vyper.readthedocs.io/)

[Solidity Tutorial](https://www.tutorialspoint.com/solidity/)

[Installing the Solidity Compiler](https://docs.soliditylang.org/en/v0.8.1/installing-solidity.html#installing)

[The Ethereum Virtual Machine (EVM)](https://docs.soliditylang.org/en/v0.8.1/introduction-to-smart-contracts.html#the-ethereum-virtual-machine)

[Remix - Ethereum IDE](https://remix.ethereum.org/)