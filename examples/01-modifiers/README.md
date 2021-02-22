# Modifiers
The smart contract explained previously is a good starting point. However, it has some flaws. For instance, it is possible to execute scoring functions (`scoreFreeThrow`, `scoreFieldGoal` and `scoreThreePointer`) after game is finished. And that is not possible in a real game. In order to fix that behaviour we could use an `if` statement at the beginning of each function, and it would work. But it requires writing the same `if` statement three times. In cases like this is better to use a `modifier`.

Modifiers are properties of contracts that can be used to change the behaviour of functions in a declarative way. In other words, modifers allow to automatically check a condition prior to executing the function. The `modifier` for our example above would be as follows:

```js
modifier gameInProgress {
  require(!gameFinished, "Game is finished. No more points!");
  _;
}
```

* Modifiers make use of `require` function, which arguments are a condition and a message in case condition is not met.
* Last line is `_;`

Now we can add the `modifier` on previous example and use it. It is mandatory to include the modifier name in the header of the desired functions.

```diff
pragma solidity >=0.4.16 <0.9.0;

contract BasketGame {
  // A enum type
  enum Team { Home, Visitor }
  
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
- function scoreFreeThrow(Team team) public {
+ function scoreFreeThrow(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints++;
    } else {
      visitorPoints++;
    }
  }
  
- function scoreFieldGoal(Team team) public {
+ function scoreFieldGoal(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints += 2;
    } else {
      visitorPoints += 2;
    }
  }
  
- function scoreThreePointer(Team team) public {
+ function scoreThreePointer(Team team) public gameInProgress {
    if (team == Team.Home) {
      homePoints += 3;
    } else {
      visitorPoints += 3;
    }
  }
  
- function finishGame() public { 
+ function finishGame() public gameInProgress {
    gameFinished = true;
  }
+
+ // Modifiers
+ modifier gameInProgress {
+   require(!gameFinished, "Game is finished. No more points!");
+   _;
+ }
}
```