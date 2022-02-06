// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interface/IManager.sol';
import './interface/IERC20.sol';
import './utils/Ownable.sol';

interface IPool {
    function pay(address _to, uint _amount) external returns (bool);
}

contract Helper is Ownable {

    IManager public manager;

    IERC20 public token;

    address public team;

    IPool public pool;
    
    uint public daoFee;

    uint private randomCallCount = 0;

    constructor(address _manager, address _token, address _pool, address teamAdrs, uint _daoFee) {
        manager = IManager(_manager);
        token = IERC20(_token);
        pool = IPool(_pool);
        team = teamAdrs;
        daoFee = _daoFee;
    }

    function updatePoolAddress(address _pool) external onlyOwner {
        pool.pay(address(owner()), token.balanceOf(address(pool)));
        pool = IPool(_pool);
    }

    function updateTeamAddress(address payable _team) external onlyOwner {
        team = _team;
    }

    function updatedaoFee(uint _fee) external onlyOwner {
        daoFee = _fee;
    }

    function _transferIt(uint contractTokenBalance) internal {
        uint teamTokens = (contractTokenBalance * daoFee) / 100;
        token.transfer(team, teamTokens);

        token.transfer(address(pool), contractTokenBalance - teamTokens);
    }

    // randomized through block timestamp, it'll be upgraded to chainlink
    function random() internal returns(uint){
        randomCallCount += 1;
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, randomCallCount)));
    }
    function isInRange(uint index, uint rangeStart, uint rangeEnd) internal pure returns(bool) {
        for(uint i = rangeStart; i <= rangeEnd; i++){
            if(i == index){
                return true;
            }
        }
        return false;
    }
    function drawTier() internal returns(uint8){
        uint tierIndex = random() % 100;
        // tier 1 6%
        if(isInRange(tierIndex, 0, 5)){
            return 1;
        }
        // tier 2 14%
        if(isInRange(tierIndex, 6, 19)){
            return 2;
        }
        // tier 3 21%
        if(isInRange(tierIndex, 20, 40)){
            return 3;
        }
        // tier 4 26%
        if(isInRange(tierIndex, 41, 66)){
            return 4;
        }
        // tier 5 33%
        if(isInRange(tierIndex, 67, 99)){
            return 5;
        }
        return 0;
    }

    function createNodeWithTokens(string memory name, uint paidAmount) public {
        require(bytes(name).length > 0 && bytes(name).length < 33, "HELPER: name size is invalid");
        address sender = _msgSender();
        require(sender != address(0), "HELPER:  Creation from the zero address");
        require(token.balanceOf(sender) >= paidAmount, "HELPER: Balance too low for creation.");
        token.transferFrom(_msgSender(), address(this), paidAmount);
        uint contractTokenBalance = token.balanceOf(address(this));
        _transferIt(contractTokenBalance);
        uint8 tier = drawTier();
        manager.createNode(sender, name, tier, paidAmount);
    }

    function claimAll() public returns (bool) {
        address sender = _msgSender();
        uint rewardAmount = manager.claimAll(sender);

        require(rewardAmount > 0,"HELPER: You don't have enough reward to cash out");
        return pool.pay(sender, rewardAmount);
    }

    function claim(uint _node) public returns (bool) {
        address sender = _msgSender();
        uint rewardAmount = manager.claim(sender, _node);

        require(rewardAmount > 0,"HELPER: You don't have enough reward to cash out");
        return pool.pay(sender, rewardAmount);
    }

    function claimAndCompoundAll() public {
        manager.claimAndCompoundAll(_msgSender());
    }

    function claimAndCompound(uint _node) public {
        manager.claimAndCompound(_msgSender(), _node);
    }
}
