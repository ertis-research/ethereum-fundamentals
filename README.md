# Ethereum Fundamentals
In this guide you will learn how to write, compile and deploy a smart contract into Ethereum mainnet or any of its testnets.

## Smart Contracts
A smart contract is a collection of code and data that resides at a specific address on the Ethereum blockchain network. Smart contracts are also a specific type of Ethereum account (they have balance and they can send transactions). However, they're not controlled by a user: they are deployed to the blockchain network and run as programmed. Users (with their Ethereum accounts) can interact with smart contracts by submitting transactions that execute functions defined on those smart contracts.

To deploy a contract to a Ethereum blockchain network it is necessary (apart from writting the contract itself) to have enought ether (ETH) on your account to carry out this operation. Deploying a smart contract is also a transaction, like a simple ETH transfer, so you will need to pay an amount of gas for contract deployment. There are two main programming languages for writting smart contracts: Solidity (similar to JavaScript) and Vyper (similar to Python). In this guide we will focus on smart contract programming using Solidity.

### Solidity
Solidity is an object-oriented, high-level language for implementing smart contracts. It has being designed to target the Ethereum Virtual Machine (EVM), is statically typed, supports inheritance, libraries and complex user-defined types (among other features).

For newcomers it is highly recommended to start programming Solidity through [Remix](#some-links). Remix is an Ethereum online IDE that eases a lot smart contracts development, including editor, compiler or debugger (among other features) in one single site. As the best way to learn a programming language is by practice, let's get down to work. Down below you can find a simple smart contract that models a basketball game.

#### Basic Example
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

#### Modifiers
The smart contract explained previously is a good starting point. However, it has some flaws. For instance, it is possible to execute scoring functions (`scoreFreeThrow`, `scoreFieldGoal` and `scoreThreePointer`) after game is finished. And that is not possible in a real game. In order to fix that behaviour we could use an `if` statement at the beginning of each function, and it would work. But it requires writing the same `if` statement three times. In cases like this is better to use a `modifier`.

Modifiers are properties of contracts that can be used to change the behaviour of functions in a declarative way. In other words, modifers allow to automatically check a condition prior to executing the function. The `modifier` for our example above would be as follows:

```sol
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

#### Events
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

#### Structs
Solidity provides a way to define new types in the form of structs. Struct types can be used inside arrays and mappings (mappings will be explained later) and structs can also contain arrays and mappings. However, it is not possible for a struct to contain a member of its own type.

To define a struct it is mandatory to use keyword `struct` and they can be located outside or inside contract definition. Defining a struct outside a contract allows it to be shared by multiple contracts, while structs defined inside contracts makes them visible only there and in derived contracts.

_Defined outside contract_
```sol
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
```sol
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

## Web3J
Work in progress...

## Infura
Work in progress...

## Faucets
Work in progress...

### Some Links
[Solidity Documentation](https://docs.soliditylang.org/)

[Vyper Documentation](https://vyper.readthedocs.io/)

[Remix - Ethereum IDE](https://remix.ethereum.org/)