// Import wallet provider library
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    ganache: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    ropsten: {
      // It is importatnt to wrap the provider as a function.
      provider: () => {
        return new HDWalletProvider({
          privateKeys: [$YOUR_ACCOUNT_PRIVATE_KEY],
          providerOrUrl: `https://ropsten.infura.io/v3/${$YOUR_INFURA_PROJECT_ID}`
        });
      },
      network_id: 3, // Ropsten network id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
    }
  }
};