pragma solidity ^0.5.16;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";

/**
 * @title Controller component
 * @dev For easy access to any core components
 */
contract Controller is Initializable {
    using Roles for Roles.Role;

    Roles.Role private _admins;
    bool private _paused;
    address public pauseGuardian;

    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    modifier onlyAdmin() {
        require(
            _admins.has(msg.sender),
            "Controller: caller does not have the admin role"
        );
        _;
    }

    modifier onlyGuardian() {
        require(
            pauseGuardian == msg.sender,
            "Controller: caller does not have the guardian role"
        );
        _;
    }

    //When using minimal deploy, do not call initialize directly during deploy, because msg.sender is the proxyFactory address, and you need to call it manually
    function initialize(address admin_) public initializer {
        _paused = false;
        _admins.add(admin_);
        pauseGuardian = admin_;
    }

    /**
     * @dev Check if the address provided is the admin
     * @param account Account address
     */
    function isAdmin(address account) public view returns (bool) {
        return _admins.has(account);
    }

    /**
     * @dev Add a new admin account
     * @param account Account address
     */
    function addAdmin(address account) public onlyAdmin {
        _admins.add(account);
    }

    /**
     * @dev Set pauseGuardian account
     * @param account Account address
     */
    function setGuardian(address account) public onlyAdmin {
        pauseGuardian = account;
    }

    /**
     * @dev Renouce the admin from the sender's address
     */
    function renounceAdmin() public {
        _admins.remove(msg.sender);
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyGuardian whenNotPaused() {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyGuardian whenPaused() {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    uint256[50] private ______gap;
}
