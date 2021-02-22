pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }

  // Event
  event FinalResult(uint home, uint visitor);
  
  // A struct/custom type
  struct Game {
    uint homePoints;
    uint visitorPoints;
    bool gameFinished;
  }
  
  // State/storage variables
  Game game;
    
  // Contract constructor
  constructor() {
    game.homePoints = 0;
    game.visitorPoints = 0;
    game.gameFinished = false;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
  function getResult() public view returns(uint, uint) {
    return(game.homePoints, game.visitorPoints);
  }
  
  function isGameFinished() public view returns(bool) {
    return(game.gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
  function scoreFreeThrow(Team team) public gameInProgress {
    if (team == Team.Home) {
      game.homePoints++;
    } else {
      game.visitorPoints++;
    }
  }
  
  function scoreFieldGoal(Team team) public gameInProgress {
    if (team == Team.Home) {
      game.homePoints += 2;
    } else {
      game.visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(Team team) public gameInProgress {
    if (team == Team.Home) {
      game.homePoints += 3;
    } else {
      game.visitorPoints += 3;
    }
  }
  
  function finishGame() public gameInProgress {
    game.gameFinished = true;
    emit FinalResult(game.homePoints, game.visitorPoints);
  }

  // Modifiers
  modifier gameInProgress {
    require(!game.gameFinished, "Game is finished. No more points!");
    _;
  }
}