const Web3 = require('web3'); // Import web3 library

const web3 = new Web3("http://localhost:7545"); // Create a Web3 instance
const basketgameContract = new web3.eth.Contract($ABI_COPIED); // Create contract instance
basketgameContract.deploy({ // Deploy contract
  data: '0x12345...', // Use Remix IDE bytecode
  arguments: []
}).send({
    from: web3.eth.accounts[0], 
    gas: '4700000'
  }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
      console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
});