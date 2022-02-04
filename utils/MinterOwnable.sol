// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Context.sol';

contract MinterOwnable is Context {
    mapping(address => bool) public _minterContracts;

    event MinterOwnershipAdded(
        address indexed minter
    );

    event MinterOwnershipRevoked(
        address indexed minter
    );

    /**
     * @dev Returns the address of the current owner.
     */
    function isMinter(address minter) public view returns (bool) {
        return _minterContracts[minter];
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyMinter() {
        require(_minterContracts[_msgSender()], "Ownable: caller is not the Minter");
        _;
    }
}