// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@axelar-network/interchain-token-service/contracts/interfaces/IInterchainTokenService.sol";
import "@axelar-network/interchain-token-service/contracts/InterchainTokenFactory.sol";
import "@axelar-network/interchain-token-service/contracts/interfaces/ITokenManagerType.sol";
import "@axelar-network/interchain-token-service/contracts/interchain-token/InterchainTokenStandard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import {AddressBytes} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressBytes.sol";

contract MyNativeInterchainToken is
    InterchainTokenStandard,
    ERC20,
    AccessControl
{
    using AddressBytes for address;

    InterchainTokenFactory itsFactory;
    IInterchainTokenService its;
    ITokenManager tokenManager;
    bytes32 public theInterchainTokenId;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address _itsFactory, address _its) ERC20("I <3 ITS", "ITS") {
        itsFactory = InterchainTokenFactory(_itsFactory);
        its = IInterchainTokenService(_its);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address account, uint256 value) public {
        _burn(account, value);
    }

    function deployTokenManager(bytes32 _salt) external payable {
        // bytes memory params = tokenManager.params(msg.sender.toBytes(), address(this)); //BREAKS!! -> why?
        bytes32 interchainId = its.deployTokenManager{value: msg.value}(
            _salt,
            "",
            ITokenManagerType.TokenManagerType.MINT_BURN,
            abi.encode(0x0, address(this)),
            msg.value
        );
        theInterchainTokenId = interchainId;
        _grantRole(MINTER_ROLE, address(its));
    }

    /**
     * Deploy from Fantom to Polygon
     * @param _salt salt from fantom
     * @param _polygonTokenAddress address of existing token on polygon
     */
    function deployRemoteTokenManager(
        bytes32 _salt,
        address _polygonTokenAddress
    ) external payable {
        bytes32 interchainId = its.deployTokenManager{value: msg.value}(
            _salt,
            "Polygon",
            ITokenManagerType.TokenManagerType.MINT_BURN,
            abi.encode(0x0, _polygonTokenAddress),
            0.1 ether
        );
        _grantRole(MINTER_ROLE, address(its)); //mint access on polygon
        theInterchainTokenId = interchainId;
    }

    function grantRole(address _newMinter) public {
        _grantRole(MINTER_ROLE, _newMinter);
    }

    // Implementations for abstract functions in InterchainTokenStandard
    function interchainTokenId()
        public
        view
        override
        returns (bytes32 tokenId_)
    {
        tokenId_ = theInterchainTokenId;
        // Provide implementation
    }

    function interchainTokenService()
        public
        view
        override
        returns (address service)
    {
        // Provide implementation
    }

    function _beforeInterchainTransfer(
        address from,
        string calldata destinationChain,
        bytes calldata destinationAddress,
        uint256 amount,
        bytes calldata metadata
    ) internal virtual override {
        // Provide implementation
    }

    function _spendAllowance(
        address sender,
        address spender,
        uint256 amount
    ) internal virtual override(ERC20, InterchainTokenStandard) {
        // Provide implementation
    }
}
