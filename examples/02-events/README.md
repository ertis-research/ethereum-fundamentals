# Events
Solidity event has the same function than in any other programming language: inform about the current state (in this case, contract state). Applications can subscribe and listen to these events through the RPC interface of an Ethereum client.

Events are inheritable members of contracts. Functions can emit events using keyword `emit`, causing event's arguments to be stored in the transaction's log. This log and its event data is not accesible from within contracts.

To create a event it is neccesary to use keyword `event`. In our contract, we could add a event to notify applications when game has finished, indicating each team scored points. Check the code down below:

```diff
pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }

+ // Event
+ event FinalResult(uint home, uint visitor);
+
  // State/storage variables
  uint homePoints;
  uint visitorPoints;
  bool gameFinished;
    
  // Contract constructor
  constructor() {
    homePoints = 0;
    visitorPoints = 0;
    gameFinished = false;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
  function getResult() public view returns(uint, uint) {
    return(homePoints, visitorPoints);
  }
  
  function isGameFinished() public view returns(bool) {
    return(gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
  function scoreFreeThrow(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints++;
    } else {
      visitorPoints++;
    }
  }
  
  function scoreFieldGoal(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints += 2;
    } else {
      visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints += 3;
    } else {
      visitorPoints += 3;
    }
  }
  
  function finishGame() public gameInProgress {
    gameFinished = true;
+   emit FinalResult(homePoints, visitorPoints);
  }

  // Modifiers
  modifier gameInProgress {
    require(!gameFinished, "Game is finished. No more points!");
    _;
  }
}
```