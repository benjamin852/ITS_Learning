import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import chains from './chains.json'
import dotenv from 'dotenv'

dotenv.config()


if (!process.env.MNEMONIC) throw ('mnemonic undefined')

if (!process.env.MNEMONIC) throw ('undefined mnemonic')


const config: HardhatUserConfig = {
  solidity: '0.8.20',
  networks: {
    polygon: {
      url: chains[0].rpc,
      accounts: { mnemonic: process.env.MNEMONIC },
      chainId: chains[0].chainId,
    },
    fantom: {
      url: chains[1].rpc,
      accounts: { mnemonic: process.env.MNEMONIC },
      chainId: chains[1].chainId,
    },
  },
}
export default config;
