pragma solidity 0.8.13;

import "forge-std/Test.sol";

import "../src/Deposit.sol";
import "lib/v2-contracts/contracts/interfaces/IERC20Mintable.sol";
import "../src/uniswap/IUniswapV2Router02.sol";
import "lib/v2-contracts/contracts/utils/Whitelist.sol";

contract LeveragedVaultTest is Test {

    IAlchemistV2 alchemist;
    IERC20Mintable dai;
    address user1;
    address daiOwner = 0xdDb108893104dE4E1C6d0E47c42237dB4E617ACc;
    IUniswapV2Router02 uniswap;
    Whitelist whitelist;
    LeveragedVaultFactory logris;
    address daiVaultAddress = 0xdA816459F1AB5631232FE5e97a05BBBb94970c95;
    Deposit depositor;

    function setUp() public {
        user1 = vm.addr(1);
        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        
        alchemist = IAlchemistV2(0x5C6374a2ac4EBC38DeA0Fc1F8716e5Ea1AdD94dd);
        address alchemixOwner = alchemist.admin();
        dai = iDAI(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        logris = new LeveragedVaultFactory();
        
        vm.deal(user1, 200 ether);
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = address(dai);
        uniswap = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        vm.prank(user1);
        uniswap.swapExactETHForTokens{value:10 ether}(1, path, user1, block.timestamp + 10000);
        depositor = new Deposit();
        
        vm.prank(alchemixOwner);
        whitelist = Whitelist(alchemist.whitelist());
        vm.prank(alchemixOwner);
        whitelist.add(address(address(depositor)));
    }

    function testLeverageCall() public {
        vm.startPrank(user1);
        dai.approve(address(depsitor), 100 ether);
        dai.transfer(address(depositor), 100 ether);
        depositor.depositToAlchemix(100 ether);
        vm.stopPrank();
        ILeveragedVault vault = ILeveragedVault(logris.vaults(daiVaultAddress));

        
    }
}
