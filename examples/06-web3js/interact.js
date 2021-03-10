const Web3 = require('web3'); // Import web3 library

const web3 = new Web3("http://localhost:7545"); // Create a Web3 instance
const basketgameContract = new web3.eth.Contract($ABI_COPIED, $CONTRACT_ADDRESS); // Create contract instance
web3.eth.getAccounts().then(response => { // Retrieve accounts
  const accounts = response;
  // Now you can try contract functions

  // 1. Create a new game
  basketgameContract.methods.createGame("UNICAJA", "BASKONIA")
  .send({from: accounts[0]})
  .then(response => {
    console.log(response); // It will return game id

    // 2. Check game result ('from' is not mandatory but recommended when using 'call')
    basketgameContract.methods.getResult(1)
    .call({from: accounts[0]})
    .then(console.log);
  });
});