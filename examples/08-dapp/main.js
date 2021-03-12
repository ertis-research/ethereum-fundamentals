const web3 = new Web3("http://localhost:7545"); // Create a Web3 instance
const basketgameContract = new web3.eth.Contract($ABI_COPIED, $CONTRACT_ADDRESS); // Create contract instance
web3.eth.net.getId().then(response => {
  document.getElementById("navbarText").textContent = `connected to network ${response}`;
});
let accounts;
web3.eth.getAccounts().then(response => { accounts = response });

// Contract functions
function createGame() {
  let teams = getTeamsNames();
  if(teams !== undefined) {
    let game_id = -1;
    basketgameContract.methods.createGame(teams[0], teams[1])
      .call({from: accounts[0]}) // Any account can be used
      .then(response => {
        game_id = response;
        basketgameContract.methods.createGame(teams[0], teams[1])
          .send({from: accounts[0]}) // Any account can be used
          .then(alert(`New game created (id ${game_id})`));
      });
  }
}

function loadGame() {
  let game_id = getGameId();
  if(game_id !== undefined) {
    basketgameContract.methods.getResult(game_id)
      .call({from: accounts[0]})
      .then(response => { processResponseGetResult(response) });
    basketgameContract.methods.isGameFinished(game_id)
    .call({from: accounts[0]})
    .then(response => {
      if(response) {
        disableOrEnableButtons(true);
      } else {
        disableOrEnableButtons(false);
      }
    });
  }
}



function scoreFreeThrow(team) {
  let game_id = getGameId();
  if(game_id !== undefined) {
    basketgameContract.methods.scoreFreeThrow(game_id, team)
      .send({from: accounts[0]})
      .then(response => loadGame());
  }
}

function scoreFieldGoal(team) {
  let game_id = getGameId();
  if(game_id !== undefined) {
    basketgameContract.methods.scoreFieldGoal(game_id, team)
      .send({from: accounts[0]})
      .then(response => loadGame());
  }
}

function scoreThreePointer(team) {
  let game_id = getGameId();
  if(game_id !== undefined) {
    basketgameContract.methods.scoreThreePointer(game_id, team)
      .send({from: accounts[0]})
      .then(response => loadGame());
  }
}

function finishGame() {
  let game_id = getGameId();
  if(game_id !== undefined) {
    let r = confirm(`Are you sure you want to finish game ${game_id}`);
    if(r) {
      basketgameContract.methods.finishGame(game_id)
        .send({from: accounts[0]})
        .then(response => loadGame());
    }
  }
}

// Auxiliar functions
function getTeamsNames() {
  let home = document.getElementsByName("home")[0].value;
  let visitor = document.getElementsByName("visitor")[0].value;
  if(home === null || home === undefined || home === "") {
    return undefined;
  } else if(visitor === null || visitor === undefined || visitor === "") {
    return undefined;
  } else {
    return [home, visitor];
  }
}

function getGameId() {
  let game_id = document.getElementsByName("game_id")[0].value;
  if(game_id === null || game_id === undefined || game_id === "") {
    return undefined;
  } else {
    return game_id;
  }
}

function processResponseGetResult(response) {
  if(response[0] !== "") {
    document.getElementsByName("homeName")[0].value = response[0];
    document.getElementsByName("homePoints")[0].value = response[1];
    document.getElementsByName("visitorName")[0].value = response[2];
    document.getElementsByName("visitorPoints")[0].value = response[3];
  } else {
    document.getElementsByName("homeName")[0].value = "---";
    document.getElementsByName("homePoints")[0].value = "---";
    document.getElementsByName("visitorName")[0].value = "---";
    document.getElementsByName("visitorPoints")[0].value = "---";
  }
}

function disableOrEnableButtons(b) {
  document.getElementById("home_1").disabled = b;
  document.getElementById("home_2").disabled = b;
  document.getElementById("home_3").disabled = b;
  document.getElementById("visitor_1").disabled = b;
  document.getElementById("visitor_2").disabled = b;
  document.getElementById("visitor_3").disabled = b;
  document.getElementById("finish").disabled = b;
}