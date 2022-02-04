// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Context.sol';

contract ManagerOwnable is Context {
    address internal _managerContract;

    event ManagerOwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Returns the address of the current owner.
     */
    function managerContract() public view returns (address) {
        return _managerContract;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyManager() {
        require(_managerContract == _msgSender(), "Ownable: caller is not the Manager");
        _;
    }
}