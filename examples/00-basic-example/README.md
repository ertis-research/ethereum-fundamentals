# Basic Example
As the best way to learn a programming language is by practice, let's get down to work. Down below you can find a simple smart contract that models a basketball game.

```js
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
  function scoreFreeThrow(Team team) public {
    if (team == Team.Home) {
      homePoints++;
    } else {
      visitorPoints++;
    }
  }
  
  function scoreFieldGoal(Team team) public {
    if (team == Team.Home) {
      homePoints += 2;
    } else {
      visitorPoints += 2;
    }
  }
  
  function scoreThreePointer(Team team) public {
    if (team == Team.Home) {
      homePoints += 3;
    } else {
      visitorPoints += 3;
    }
  }
  
  function finishGame() public {
    gameFinished = true;
  }
}
```

As this contract is the first one you ever seen, let's explain it completely:
* The first line must always be `pragma solidity` followed by compiler version(s).
* It is not mandatory but recommended that contract name should be the same as file name.
* `enum` types are similar than other programming languages.
* State variables can be declared in the `contract` part and they are stored in contract `storage`.
* `constructor` is executed only once, after contract deployment.
* Functions that don't modify storage don´t consume gas. Keyword `view` is used to declare that this kind of functions do not modify state.
* Functions that modify state/storage are called transactions and use gas.