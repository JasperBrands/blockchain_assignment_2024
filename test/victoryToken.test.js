const VictoryToken = artifacts.require("VictoryToken");

contract("VictoryToken", (accounts) => {
    let victoryTokenInstance;

    before(async () => {
        victoryTokenInstance = await VictoryToken.deployed();
    });

    describe("mint", () => {
        it("should mint the specified amount of tokens and increase the total supply", async () => {
            // Minting 100 tokens to accounts[0]
            await victoryTokenInstance._mint(accounts[0], 100);

            // Getting the balance of accounts[0]
            const balanceOfAccount0 = await victoryTokenInstance.balanceOf(accounts[0]);

            // Getting the total supply
            const totalSupply = await victoryTokenInstance.totalSupply();

            // Assert the correct balance and total supply
            assert.equal(balanceOfAccount0, 100, "Should mint 100 tokens to accounts[0]");
            assert.equal(totalSupply, 100, "Total supply should increase to 100");
        });
    });

    // describe("transfer", () => {
    //     it("should transfer the specified amount of tokens from one account to another", async () => {
    //         // Minting 100 tokens to accounts[0]
    //         await victoryTokenInstance._mint(accounts[0], 100);

    //         // Transferring 50 tokens from accounts[0] to accounts[1]
    //         await victoryTokenInstance.transfer(accounts[1], 50);

    //         // Getting the balances of accounts[0] and accounts[1]
    //         const balanceOfAccount0 = await victoryTokenInstance.balanceOf(accounts[0]);
    //         const balanceOfAccount1 = await victoryTokenInstance.balanceOf(accounts[1]);

    //         // Assert the correct balances
    //         assert.equal(balanceOfAccount0, 50, "Should transfer 50 tokens from accounts[0]");
    //         assert.equal(balanceOfAccount1, 50, "Should receive 50 tokens in accounts[1]");
    //     });
    // });

    describe("approve", () => {
        it("should approve the specified spender to spend the specified amount of tokens", async () => {
            // Approving accounts[1] to spend 50 tokens on behalf of accounts[0]
            await victoryTokenInstance.approve(accounts[1], 50, { from: accounts[0] });

            // Getting the allowance of accounts[0] for accounts[1]
            const allowance = await victoryTokenInstance.allowance(accounts[0], accounts[1]);

            // Assert the correct allowance
            assert.equal(allowance, 50, "Should approve accounts[1] to spend 50 tokens on behalf of accounts[0]");
        });
    });

    // describe("transferFrom", () => {
    //     it("should transfer the specified amount of tokens from one account to another using allowance", async () => {
    //         // Minting 100 tokens to accounts[0]
    //         await victoryTokenInstance._mint(accounts[0], 100);

    //         // Approving accounts[1] to spend 50 tokens on behalf of accounts[0]
    //         await victoryTokenInstance.approve(accounts[1], 50, { from: accounts[0] });

    //         // Transferring 50 tokens from accounts[0] to accounts[1] using allowance
    //         await victoryTokenInstance.transferFrom(accounts[0], accounts[1], 50, { from: accounts[1] });

    //         // Getting the balances of accounts[0] and accounts[1]
    //         const balanceOfAccount0 = await victoryTokenInstance.balanceOf(accounts[0]);
    //         const balanceOfAccount1 = await victoryTokenInstance.balanceOf(accounts[1]);

    //         // Assert the correct balances
    //         assert.equal(balanceOfAccount0, 50, "Should transfer 50 tokens from accounts[0]");
    //         assert.equal(balanceOfAccount1, 50, "Should receive 50 tokens in accounts[1]");
    //     });
    // });
});
