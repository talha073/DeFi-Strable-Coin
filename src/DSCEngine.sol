// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
* @title: Decentralized Stable Coin Engine
* @author: Talha
*
* This system is design to be as minimal as posible, and have the tokens maintain a 1 token =   $1 peg.
*
* this systme has the following properties:moreThanZero
* - Exogenous Collateral
* - Dollar pegged
* - Algorithimic Stable
*
* This is similar to DAI. If DAI had no governance, no fees, and was only backed by WETH and WBTC
*
* Our DSC system should always be "overcollateraized". At no point, should the value of all collateral <= the $ backed value of all the DSC. 
*
* @notice: This contract is the core of the DCS System. It handles all the logics for minting and redeeming DCS, as well as depositing and withdrawing collateral. 
* @notice: This contract is very loosly based on the makerDAO (DAI) system
*/
contract DSCEngine is ReentrancyGuard {

    //!errors
    error DSCEngine__NeedsMoreThanZero(); 
    error DSCEngine__TokenAddressAndPriceFeedAddressMustBeSameLength(); 
    error DSCEngine__NotAllowedToken();

    //!state variables
    mapping (address token => address priceFeed) private s_priceFeed;  //token => priceFeed
    mapping (address user => mapping(address token => uint256 amount)) private s_collateralDeposited ;
    DecentralizedStableCoin private immutable i_dsc;

    //!modifiers
    modifier moreThanZero(uint256 amount) {
        // require((amount > uint256(0)), "Amount must not be zero");
        if(amount == 0){
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }
    modifier isAllowedToken(address token) {
        if(s_priceFeed[token] == address(0)){
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }
    
    //!functions
    constructor (
        address[] memory tokenAddress, address[] memory priceFeedAddress, address dscAddress
    ) {
        //USD priceFeed
        if(tokenAddress.length != priceFeedAddress.length){
            revert DSCEngine__TokenAddressAndPriceFeedAddressMustBeSameLength();
        }
        for(uint256 i = 0; i < tokenAddress.length; i++){
            s_priceFeed[tokenAddress[i]] = priceFeedAddress[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    //!external functions
    function depositeCollateralAndMintDsc() external {}


    /**
     * @param tokenCollateralAddress The address of the token todeposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositeCollateral(address tokenCollateralAddress, uint256 amountCollateral) external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant 
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;

    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}
    function liquidate() external {
        //$100 ETH  --> $40 (liquidated) $60 --> kickout from the system because you are too close
        //$50 DSC
    }

    function getHealthFactor() external view {}
}
