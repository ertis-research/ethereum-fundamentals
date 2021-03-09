pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }
  
  // event
  event FinalResult(string message, uint home, uint visitor);
  
  // A struct/custom type
  struct Game {
    string homeName;
    uint homePoints;
    string visitorName;
    uint visitorPoints;
    bool gameFinished;
  }
  
  // State/storage variables
  Game game;
    
  // Contract constructor
  constructor(string memory home, string memory visitor) {
    game.homeName = home;
    game.homePoints = 0;
    game.visitorName = visitor;
    game.visitorPoints = 0;
    game.gameFinished = false;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
  function getResult() external view returns(string memory, uint, string memory, uint) {
    return(game.homeName, game.homePoints, game.visitorName, game.visitorPoints);
  }
  
  function isGameFinished() external view returns(bool) {
    return(game.gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
  function scoreFreeThrow(Team team) external gameInProgress {
    if (team == Team.Home) {
      game.homePoints++;
    } else {
      game.visitorPoints++;
    }
  }
  
  function scoreFieldGoal(Team team) external gameInProgress {
    if (team == Team.Home) {
      game.homePoints += 2;
    } else {
      game.visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(Team team) external gameInProgress {
    if (team == Team.Home) {
      game.homePoints += 3;
    } else {
      game.visitorPoints += 3;
    }
  }
  
  function finishGame() external gameInProgress {
    game.gameFinished = true;
    if (game.homePoints > game.visitorPoints) {
      emit FinalResult(concatenate(game.homeName, " has won"), game.homePoints, game.visitorPoints);
    } else {
      emit FinalResult(concatenate(game.visitorName, " has won"), game.homePoints, game.visitorPoints);
    }
  }

  // Modifiers
  modifier gameInProgress {
    require(!game.gameFinished, "Game is finished. No more points!");
    _;
  }
  
  // String manipulation functions
  function length(string calldata str) internal pure returns(uint) {
    return bytes(str).length;
  }
  
  function concatenate(string storage a, string memory b) internal pure returns(string memory) {
    return string(abi.encodePacked(a,b));
  }
}