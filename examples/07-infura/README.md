# Infura

In this example we are going to deploy a smart contract in Ropsten testnet. Nevertheless, __Infura is only an API provider, it does not provide a wallet or an account service__. In other words, the endpoint/node provided by Infura has zero accounts, so when calling function `web3.eth.getAccounts` no account will be retrieved.

If we want to use our accounts generated with Metamask, it is mandatory to make use of `@truffle/hdwallet-provider` library. Importing an account with this library has the following syntax:

```js
const Web3 = require('web3'); // Import web3 library
const HDWalletProvider = require("@truffle/hdwallet-provider"); // Import hdwallet-provider library

// Create the provider
const provider = new HDWalletProvider({
  privateKeys: [$YOUR_ACCOUNT_PRIVATE_KEY],
  providerOrUrl: `https://ropsten.infura.io/v3/${$YOUR_INFURA_PROJECT_ID}`
});
const web3 = new Web3(provider); // Create a Web3 instance using the provider

// ...
// Deployment code (the same as before).
// ...

// At termination, `provider.engine.stop()' should be called to finish the process elegantly.
provider.engine.stop();
```

Before executing the JavaScript file, replace variables `$YOUR_ACCOUNT_PRIVATE_KEY` and `$YOUR_INFURA_PROJECT_ID`. Then, install Node dependencies (`web3` and `@truffle/hdwallet-provider`) and, finally, execute the code.

```bash
npm install
npm run deploy
```

### Useful links
[web3.js - getAccounts](https://web3js.readthedocs.io/en/v1.2.11/web3-eth.html#getaccounts)

[@truffle/hdwallet-provider library](https://github.com/trufflesuite/truffle/tree/develop/packages/hdwallet-provider)