import { ethers } from 'hardhat'
import chains from '../chains.json'

async function main() {

    const myInterhchainToken = await ethers.deployContract('MyNativeInterchainToken', [
        chains[0].itsFactory,
        chains[0].its,
    ])

    await myInterhchainToken.waitForDeployment()
    console.log(`polygon contract address: ${myInterhchainToken.target}`)
}
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
