// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./USDC.sol";

contract USDCFaucet is Ownable {
    USDCToken internal _usdc;
    mapping(address => uint) internal lastRequestedMap;
    uint internal timeout;
    uint256 internal faucetAmount;
    constructor (uint256 _vendAmount) Ownable(msg.sender, msg.sender) {
        _usdc = new USDCToken(_vendAmount*10000000, address(this));
        faucetAmount = _vendAmount;
        timeout = 10 hours;
    }


    modifier cooldown {
        require(block.timestamp >= (lastRequestedMap[msg.sender]+timeout), "Cooldown 10 hours have not passed");
        _;
    }

    modifier balanceAvailable(uint256 balance) {
        require(_usdc.balanceOf(address(this))>=balance, "not enough balance, ping @__spongeboi");
        _;
    }

    function request() public cooldown balanceAvailable(faucetAmount) {
        _usdc.transfer(msg.sender, faucetAmount);
        lastRequestedMap[msg.sender] =  block.timestamp;
    }

    function forceWithdraw(address to, uint256 amount) public onlyOwner balanceAvailable(amount){
        _usdc.transfer(to, amount);
    }

    function balanceLeft() external view returns(uint256) {
        return _usdc.balanceOf(address(this));
    }

    function newUSDCAddr() external onlyOwner {
        _usdc = new USDCToken(faucetAmount*10000000, address(this));
    }

    function _mint(uint256 amount) internal {
        _usdc.mint(address(this), amount);
    }

    function increaseSupply(uint256 amount) public onlyOwner {
        _mint(amount);
    }

    function changeFaucetAmount(uint256 amount) public onlyOwner {
        faucetAmount = amount;
    }
}
