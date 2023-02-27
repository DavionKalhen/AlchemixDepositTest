pragma solidity 0.8.13;

import "lib/v2-contracts/contracts/interfaces/IAlchemistV2.sol";
import "lib/v2-contracts/contracts/interfaces/IERC20Mintable.sol";

contract Depositor {
    address alchemix = 0x5C6374a2ac4EBC38DeA0Fc1F8716e5Ea1AdD94dd;
    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function depositToAlchemix(uint256 amount) external {
        IERC20Mintable daiToken = IERC20Mintable(dai);
        daiToken.approve(alchemix, amount);
        IAlchemistV2(alchemix).depositUnderlying(dai, amount, msg.sender, 1);
    }
}