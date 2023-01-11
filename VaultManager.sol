pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VaultManager is Ownable {
    mapping(address => mapping(address => uint256)) public vaults;

    event Deposit(address indexed vault, address indexed owner, uint256 value);
    event Withdrawal(address indexed vault, address indexed owner, uint256 value);

    function createVault(address token) public {
        require(msg.sender == owner);
        address vault = address(this);
        vaults[vault][msg.sender] = 0;
    }

    function deposit(address vault, address token, uint256 value) public {
        require(vault == address(this));
        require(msg.sender == vaults[vault][msg.sender]);
        ERC20(token).transferFrom(msg.sender, vault, value);
        vaults[vault][msg.sender] += value;
        emit Deposit(vault, msg.sender, value);
    }

    function withdraw(address vault, address token, uint256 value) public {
        require(vault == address(this));
        require(vaults[vault][msg.sender] >= value);
        ERC20(token).transfer(msg.sender, value);
        vaults[vault][msg.sender] -= value;
        emit Withdrawal(vault, msg.sender, value);
    }
}
