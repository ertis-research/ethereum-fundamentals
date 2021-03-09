# Strings
Unlike other programming languages, Solidity does not provide string manipulation functions as determining the string's length, concatenating two strings or comparing two strings. If we need any of these, we have to do it manually.

In order to learn a bit how to work with strings on Solidity, let's add two `string` members to the struct `Game` (each one will store a team name). In addtion,  event `FinalResult` can include a message saying which team has won the game. And, obviously, we are going to create a couple of functions to manipulate those strings.

```diff
pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }

  // Event
- event FinalResult(uint home, uint visitor);
+ event FinalResult(string message, uint home, uint visitor);
  
  // A struct/custom type
  struct Game {
+   string homeName;
    uint homePoints;
+   string visitorName;
    uint visitorPoints;
    bool gameFinished;
  }
  
  // State/storage variables
  Game game;
    
  // Contract constructor
- constructor() {
+ constructor(string memory home, string memory visitor) {
+   game.homeName = home;  
    game.homePoints = 0;
+   game.visitorName = visitor;
    game.visitorPoints = 0;
    game.gameFinished = false;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
- function getResult() external view returns(uint, uint) {
-   return(game.homePoints, game.visitorPoints);
+ function getResult() external view returns(string memory, uint, string memory, uint) {
+   return(game.homeName, game.homePoints, game.visitorName, game.visitorPoints);
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
-   emit FinalResult(game.homePoints, game.visitorPoints);
+   if (game.homePoints > game.visitorPoints) {
+     emit FinalResult(concatenate(game.homeName, " has won"), game.homePoints, game.visitorPoints);
+   } else {
+     emit FinalResult(concatenate(game.visitorName, " has won"), game.homePoints, game.visitorPoints);
+   }
  }

  // Modifiers
  modifier gameInProgress {
    require(!game.gameFinished, "Game is finished. No more points!");
    _;
  }

+ // String manipulation functions
+ function length(string calldata str) internal pure returns(uint) {
+   return bytes(str).length;
+ }
+
+ function concatenate(string storage a, string memory b) internal pure returns(string memory) {
+   return string(abi.encodePacked(a,b));
+ }
}
```

As you could see, there is a lot to explain in this example:
* Now the constructor needs two arguments, local team name and visitor team name.
* Function `finishGame` has to determine which team has won the game, emitting the event with a message like `Team1 has won`.
* String manipulation function `length` converts the desired string to type `bytes`, since this type has `length`.
* String manipulation function `concatenate` makes use of `abi.encodePacked` which concatenates two arguments, transforming result into `bytes` type. That is why after above mentioned function a cast to `string` type is used..
* Both manipulation functions are `pure` because **they do not read or modify contract state**. They also marked as `internal` because they are only called within the contract.

### Useful links
[String literals](https://docs.soliditylang.org/en/v0.8.1/types.html#string-literals-and-types)

[Strings as arrays](https://docs.soliditylang.org/en/v0.8.1/types.html#bytes-and-strings-as-arrays)

[String manipulation in Solidity (video)](https://www.youtube.com/watch?v=gNlwpr3vGYM)

[Working with strings in Solidity](https://coders-errand.com/working-with-strings-in-solidity/)

[Pure functions](https://www.tutorialspoint.com/solidity/solidity_pure_functions.htm)