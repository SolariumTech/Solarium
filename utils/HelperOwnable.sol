// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Context.sol';

contract HelperOwnable is Context {
    address internal _helperContract;

    event HelperOwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Returns the address of the current owner.
     */
    function helperContract() public view returns (address) {
        return _helperContract;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyHelper() {
        require(_helperContract == _msgSender(), "Ownable: caller is not the helper");
        _;
    }
}