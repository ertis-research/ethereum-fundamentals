pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }

  // Event
  event FinalResult(uint home, uint visitor);
  
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
    emit FinalResult(homePoints, visitorPoints);
  }

  // Modifiers
  modifier gameInProgress {
    require(!gameFinished, "Game is finished. No more points!");
    _;
  }
}