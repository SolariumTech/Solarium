// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IERC721.sol';

interface IManager is IERC721 {
    // function price() external returns(uint256);
    function createNode(address account, string memory nodeName, uint8 tier, uint paidAmount) external;
    function claim(address account, uint256 _id) external returns (uint);
    function claimAndCompound(address account, uint _id) external;
    function claimAll(address account) external returns (uint);
    function claimAndCompoundAll(address account) external;
    function stake(address account, uint id, uint amountToStake) external;
}