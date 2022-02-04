// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Context.sol';

contract WeigthOwnable is Context {
    address internal _weigthContract;

    event WeigthOwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _weigthContract = msgSender;
        emit WeigthOwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function weigthContract() public view returns (address) {
        return _weigthContract;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyWeigth() {
        require(_weigthContract == _msgSender(), "Ownable: caller is not the weight");
        _;
    }
}