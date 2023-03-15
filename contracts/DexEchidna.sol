// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Dex.sol";

contract DexEchidna {
    SwappableToken public token1;
    SwappableToken public token2;
    Dex dex;

    event DebugDexToken1(uint256);
    event DebugDexToken2(uint256);
    event DebugEchidnaToken1(uint256);
    event DebugEchidnaToken2(uint256);

    constructor() {
        dex = new Dex();
        // 10 tokens of each token get minted to the echidna contract => (address(this)) is msg.sender
        token1 = new SwappableToken(address(dex), "TokenOne", "ONE", 110 ether);
        token2 = new SwappableToken(address(dex), "TokenTwo", "TWO", 110 ether);
        // dex token addresses get set here
        dex.setTokens(address(token1), address(token2));
        // dex gets 100 tokens of each token sent from echidna so the starting conditions are met
        token1.transfer(address(dex), 100 ether);
        token2.transfer(address(dex), 100 ether);
    }

    function testStartingConditions() public {
        emit DebugDexToken1(token1.balanceOf(address(dex)));
        emit DebugDexToken2(token2.balanceOf(address(dex)));
        emit DebugEchidnaToken1(token1.balanceOf(address(this)));
        emit DebugEchidnaToken2(token2.balanceOf(address(this)));
        assert(token1.balanceOf(address(this)) < 10);
    }
}
