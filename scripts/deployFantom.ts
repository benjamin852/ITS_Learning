import { ethers } from 'hardhat'
import chains from '../chains.json'

async function main() {


    const randomBytes = ethers.randomBytes(32);
    const salt = ethers.hexlify(randomBytes);

    console.log(salt, 'the salt')
    // 0x0c5a6b24628d8856de2c1b77ccc5e9a8a8fbaeb312c986833a8f311832aec8b7
    const myInterhchainToken = await ethers.deployContract('MyNativeInterchainToken', [
        chains[1].itsFactory,
        chains[1].its
    ])

    await myInterhchainToken.waitForDeployment()
    console.log(`fantom contract address: ${myInterhchainToken.target}`)
}
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
