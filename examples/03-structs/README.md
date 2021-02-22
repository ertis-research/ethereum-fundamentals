# Structs
Solidity provides a way to define new types in the form of structs. Struct types can be used inside arrays and mappings (mappings will be explained later) and structs can also contain arrays and mappings. However, it is not possible for a struct to contain a member of its own type.

To define a struct it is mandatory to use keyword `struct` and they can be located outside or inside contract definition. Defining a struct outside a contract allows it to be shared by multiple contracts, while structs defined inside contracts makes them visible only there and in derived contracts.

_Defined outside contract_
```js
pragma solidity >=0.4.16 <0.9.0;

struct Game {
  uint homePoints;
  uint visitorPoints;
  bool gameFinished;
}

contract BasketGame {
  ...
}
```
_Defined inside contract_
```js
pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  struct Game {
    uint homePoints;
    uint visitorPoints;
    bool gameFinished;
  }
  ...
}
```

Let's modify our contract and include the above mentioned struct.

```diff
pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }

  // Event
  event FinalResult(uint home, uint visitor);

+ // A struct/custom type
+ struct Game {
+   uint homePoints
+   uint visitorPoints
+   bool gameFinished
+ }
+  
  // State/storage variables
- uint homePoints;
- uint visitorPoints;
- bool gameFinished;
+ Game game;
    
  // Contract constructor
  constructor() {
-   homePoints = 0;
-   visitorPoints = 0;
-   gameFinished = false;
+   game.homePoints = 0;
+   game.visitorPoints = 0;
+   game.gameFinished = false;
  }
  
  // Functions that DON'T MODIFY contract storage. They don´t use gas
  function getResult() public view returns(uint, uint) {
-   return(homePoints, visitorPoints);
+   return(game.homePoints, game.visitorPoints);
  }
  
  function isGameFinished() public view returns(bool) {
-   return(gameFinished);
+   return(game.gameFinished);
  }
  
  // Transactions or functions that DO MOFIFY contract storage. They use gas
  function scoreFreeThrow(Team team) public gameInProgress {
    if (team == Team.Home) {
-     homePoints++;
+     game.homePoints++;
    } else {
-     visitorPoints++;
+     game.visitorPoints++; 
    }
  }
  
  function scoreFieldGoal(Team team) public gameInProgress {
    if (team == Team.Home) {
-     homePoints += 2;
+     game.homePoints += 2;
    } else {
-     visitorPoints += 2;
+     game.visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(Team team) public gameInProgress {
    if (team == Team.Home) {
-     homePoints += 3;
+     game.homePoints += 3;
    } else {
-     visitorPoints += 3;
+     game.visitorPoints += 3;
    }
  }
  
  function finishGame() public gameInProgress {
-   gameFinished = true;
-   emit FinalResult(homePoints, visitorPoints);
+   game.gameFinished = true;
+   emit FinalResult(game.homePoints, game.visitorPoints);
  }

  // Modifiers
  modifier gameInProgress {
-   require(!gameFinished, "Game is finished. No more points!");
+   require(!game.gameFinished, "Game is finished. No more points!");
    _;
  }
}
```

Of course, it is possible to directly access the members of the struct without assigning it to a local variable, as in `game.gameFinished = true`.