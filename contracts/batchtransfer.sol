// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./IERC20.sol";


// Contract to batch transfer ERC20 tokens
// msg.sender must allow this contract to spend the tokens by calling approve() on the ERC20 token contract
contract BatchTransfer {
    constructor () {}


    modifier erc20TokensAvailable(uint256[] memory amounts, address erc20Token) {
        uint256 totalAmount = 0;
        for (uint i = 0; i<amounts.length; i++) {
            totalAmount += amounts[i];
        }
        IERC20 _currency = IERC20(erc20Token);
        require(_currency.balanceOf(msg.sender) >= totalAmount, "Balance Not Enough");
        require(_currency.allowance(msg.sender, address(this))>=totalAmount, "Not Allowed to spend");
        _;
    }

    function groupTransfer(address[] memory addrs, uint256[] memory amounts, address erc20Token) public erc20TokensAvailable(amounts, erc20Token) 
    returns(bool) {
        IERC20 _currency = IERC20(erc20Token);
        for (uint i = 0; i<amounts.length; i++) {
            bool _success = _currency.transferFrom(msg.sender, addrs[i], amounts[i]);
            require(_success, "Couldn't transfer to addr");
        }
        return true;
    }

}