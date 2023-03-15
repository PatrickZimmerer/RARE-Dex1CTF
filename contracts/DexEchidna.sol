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
    event DebugContractOwner(address);

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

    function testStartingConditions(
        address from,
        address to,
        uint amount
    ) public {
        // optimize fuzzer to only transfer between valid addresses
        if (from != address(token1) && from != address(token2)) {
            if (to == address(token1)) {
                from = address(token2);
            } else if (to == address(token2)) {
                from = address(token1);
            } else {
                from = address(token1);
                to = address(token2);
            }
        }
        dex.swap(from, to, amount);
        assert(token1.balanceOf(address(dex)) > 79);
        assert(token2.balanceOf(address(dex)) > 79);
    }
}
