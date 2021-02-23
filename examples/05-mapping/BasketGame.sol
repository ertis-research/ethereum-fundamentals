pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }
  
  // event
  event FinalResult(uint game_id, string message, uint home, uint visitor);
  
  // A struct/custom type
  struct Game {
    string homeName;
    uint homePoints;
    string visitorName;
    uint visitorPoints;
    bool gameFinished;
  }
  
  // State/storage variables
  mapping(uint => Game) games;
  uint next_id;
    
  // Contract constructor
  constructor() {
    next_id = 1;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
  function getResult(uint game_id) external view returns(uint, uint) {
    return(games[game_id].homePoints, games[game_id].visitorPoints);
  }
  
  function isGameFinished(uint game_id) external view returns(bool) {
    return(games[game_id].gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
  function createGame(string memory homeTeam, string memory visitorTeam) external returns(uint) {
    games[next_id].homeName = homeTeam;
    games[next_id].homePoints = 0;
    games[next_id].visitorName = visitorTeam;
    games[next_id].visitorPoints = 0;
    games[next_id].gameFinished = false;
    next_id++;
    return(next_id-1);
  }
  
  function scoreFreeThrow(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
      games[game_id].homePoints++;
    } else {
      games[game_id].visitorPoints++;
    }
  }
  
  function scoreFieldGoal(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
      games[game_id].homePoints += 2;
    } else {
      games[game_id].visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
      games[game_id].homePoints += 3;
    } else {
      games[game_id].visitorPoints += 3;
    }
  }
  
  function finishGame(uint game_id) external gameInProgress(game_id) {
    games[game_id].gameFinished = true;
    if (games[game_id].homePoints > games[game_id].visitorPoints) {
      emit FinalResult(game_id, concatenate(games[game_id].homeName, " has won"), games[game_id].homePoints, games[game_id].visitorPoints);
    } else {
      emit FinalResult(game_id, concatenate(games[game_id].visitorName, " has won"), games[game_id].homePoints, games[game_id].visitorPoints);
    }
  }

  // Modifiers
  modifier gameInProgress(uint game_id) {
    require(!games[game_id].gameFinished, "Game is finished. No more points!");
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