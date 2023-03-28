// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Dex.sol";

contract DexEchidna {
    SwappableToken public token1;
    SwappableToken public token2;
    Dex dex;

    event BalanceA(uint256);
    event BalanceB(uint256);

    constructor() {
        dex = new Dex();
        // 10 tokens of each token get minted to the echidna contract => (address(this)) is msg.sender
        token1 = new SwappableToken(address(dex), "TokenOne", "ONE", 110 ether);
        token2 = new SwappableToken(address(dex), "TokenTwo", "TWO", 110 ether);
        // dex token addresses get set here
        dex.setTokens(address(token1), address(token2));
        // dex gets 100 tokens of each token so echidna has 10 of each and the starting conditions are met
        token1.transfer(address(dex), 100 ether);
        token2.transfer(address(dex), 100 ether);
        dex.renounceOwnership();
        // renounce ownership & approve the dex for handling my tokens
        dex.approve(address(dex), (2 ** 256 - 1));
    }

    function testSwap(bool aToB, uint256 amount) public {
        address from;
        address to;
        if (aToB) {
            from = address(token1);
            to = address(token2);
        } else {
            from = address(token2);
            to = address(token1);
        }
        amount = 1 ether + (amount % IERC20(from).balanceOf(address(this)));

        dex.swap(from, to, amount);

        emit BalanceA(token1.balanceOf(address(this)));
        emit BalanceB(token2.balanceOf(address(this)));
        assert(token1.balanceOf(address(dex)) > 60 ether);
        assert(token2.balanceOf(address(dex)) > 60 ether);
    }
}
