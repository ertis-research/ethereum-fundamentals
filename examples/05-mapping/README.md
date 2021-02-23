# Mapping
So far we have seen most of the fundamental features of Solidity. Nevertheless, the smart contract coded is not quite useful. Did you notice that, after executing transaction `finishGame`, the contract cannot execute more transactions? If the game is finished you can only get the result. Would it not be more logic to store a list of games instead a single one? Of course! Let's introduce `mapping`.

Mapping is a reference type as arrays or structs. A mapping type variable is declared using the syntax `mapping(_KeyType => _ValueType) _VariableName`. `_KeyType` can be any built-in type (`uint`, `bool`, etc), `bytes`, `string` or enum type. No reference types or complex objects are allowed. `_ValueType` can be any type. Mapping can only have type of `storage` and are generally used for state variables.

In our example, the mapping would be `mapping(uint => Game) games`, where key is game id and value `Game` type.

```diff
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
- Game game;
+ mapping(uint => Game) games;
+ uint next_id;
    
  // Contract constructor
- constructor(string memory home, string memory visitor) {
-   game.homeName = home;
-   game.homePoints = 0;
-   game.visitorName = visitor;
-   game.visitorPoints = 0;
-   game.gameFinished = false;
- }
+ constructor() {
+   next_id = 1;
+ }

  // Functions that DON'T MODIFY contract storage. They don´t use gas
- function getResult() external view returns(uint, uint) {
-   return(game.homePoints, game.visitorPoints);
+ function getResult(uint game_id) external view returns(uint, uint) {
+   return(games[game_id].homePoints, games[game_id].visitorPoints);
  }
  
- function isGameFinished() external view returns(bool) {
-   return(game.gameFinished);
+ function isGameFinished(uint game_id) external view returns(bool) {
+   return(games[game_id].gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
+ function createGame(string memory homeTeam, string memory visitorTeam) external returns(uint) {
+   games[next_id].homeName = homeTeam;
+   games[next_id].homePoints = 0;
+   games[next_id].visitorName = visitorTeam;
+   games[next_id].visitorPoints = 0;
+   games[next_id].gameFinished = false;
+   next_id++;
+   return(next_id-1);
+ }
+  
- function scoreFreeThrow(Team team) external gameInProgress {
+ function scoreFreeThrow(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
-     game.homePoints++;
+     games[game_id].homePoints++;
    } else {
-     game.visitorPoints++;
+     games[game_id].visitorPoints++;
    }
  }
  
- function scoreFieldGoal(Team team) external gameInProgress {
+ function scoreFieldGoal(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
-     game.homePoints += 2;
+     games[game_id].homePoints += 2;
    } else {
-     game.visitorPoints += 2;
+     games[game_id].visitorPoints += 2;
    }
  }
  
- function scoreThreePointer(Team team) external gameInProgress {
+ function scoreThreePointer(uint game_id, Team team) external gameInProgress(game_id) {
    if (team == Team.Home) {
-     game.homePoints += 3;
+     games[game_id].homePoints += 3;
    } else {
-     game.visitorPoints += 3;
+     games[game_id].visitorPoints += 3;
    }
  }
  
- function finishGame() external gameInProgress {
-   game.gameFinished = true;
-   if (game.homePoints > game.visitorPoints) {
-     emit FinalResult(concatenate(game.homeName, " has won"), game.homePoints, game.visitorPoints);
-   } else {
-     emit FinalResult(concatenate(game.visitorName, " has won"), game.homePoints, game.visitorPoints);
-   }
- }
+ function finishGame(uint game_id) external gameInProgress(game_id) {
+   games[game_id].gameFinished = true;
+   if (games[game_id].homePoints > games[game_id].visitorPoints) {
+     emit FinalResult(game_id, concatenate(games[game_id].homeName, " has won"), games[game_id].homePoints, games[game_id].visitorPoints);
+   } else {
+     emit FinalResult(game_id, concatenate(games[game_id].visitorName, " has won"), games[game_id].homePoints, games[game_id].visitorPoints);
+   }
+ }

  // Modifiers
- modifier gameInProgress {
-   require(!game.gameFinished, "Game is finished. No more points!");
+ modifier gameInProgress(uint game_id) {
+   require(!games[game_id].gameFinished, "Game is finished. No more points!");
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
```

Major contract modifications are explained:
* Contract state is composed by the `mapping` containing a list of games (`games`) and a counter that will be incremented with each new game (`next_id`).
* All `external` functions have an additional argument, `game_id` which indicates game identifier.
* A new function, `createGame` has been included. It will return new game identifier.
* Modifier `gameInProgress` has one argument. Again, `game_id`. The correct syntax to use a `modifier` with at least one argument is the one shown above, `function finishGame(uint game_id) external gameInProgress(game_id)`

### Useful links
[Mapping Types](https://docs.soliditylang.org/en/v0.8.1/types.html#mapping-types)