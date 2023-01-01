// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";

contract USDCToken is ERC20, Ownable {
    constructor(uint256 initialSupply, address holder) ERC20("USDC", "USDC") Ownable(msg.sender, msg.sender){
        _mint(holder, initialSupply);
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    function mint(address holder, uint256 supply) public onlyOwner {
        _mint(holder, supply);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}