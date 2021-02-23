# Ethereum Fundamentals
In this guide you will learn how to write, compile and deploy a smart contract into Ethereum mainnet or any of its testnets.

## Smart Contracts
A smart contract is a collection of code and data that resides at a specific address on the Ethereum blockchain network. Smart contracts are also a specific type of Ethereum account (they have balance and they can send transactions). However, they're not controlled by a user: they are deployed to the blockchain network and run as programmed. Users (with their Ethereum accounts) can interact with smart contracts by submitting transactions that execute functions defined on those smart contracts.

To deploy a contract to a Ethereum blockchain network it is necessary (apart from writting the contract itself) to have enought ether (ETH) on your account to carry out this operation. Deploying a smart contract is also a transaction, like a simple ETH transfer, so you will need to pay an amount of gas for contract deployment. There are two main programming languages for writting smart contracts: Solidity (similar to JavaScript) and Vyper (similar to Python). In this guide we will focus on smart contract programming using Solidity.

### Solidity
Solidity is an object-oriented, high-level language for implementing smart contracts. It has being designed to target the Ethereum Virtual Machine (EVM), is statically typed, supports inheritance, libraries and complex user-defined types (among other features).

For newcomers it is highly recommended to start programming Solidity through [Remix](#some-links). Remix is an Ethereum  IDE that eases a lot smart contracts development, including editor, compiler or debugger (among other features) in one single site. In order to present Solidity main features, directory [examples](./examples) includes a series of smart contracts that use some of those characteristics.

## Development environments

### Remix
Remix IDE is an open source web and desktop application. It allows a fast development cycle and has a rich set of plugins with intuitive GUIs. Remix is used for the entire journey of contract development as well as being a playground for learning and teaching Ethereum.

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

[Solidity Tutorial](https://www.tutorialspoint.com/solidity/)

[Vyper Documentation](https://vyper.readthedocs.io/)

[Remix - Ethereum IDE](https://remix.ethereum.org/)