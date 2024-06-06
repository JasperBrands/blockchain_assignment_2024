// AntToken.test.js
const AntToken = artifacts.require("AntToken");

contract("AntToken", (accounts) => {
    let antTokenInstance;

    before(async () => {
        antTokenInstance = await AntToken.deployed();
    });

    describe("balanceOf", () => {
        it("should return the balance of the specified owner", async () => {
            // Getting the balance of accounts[0]
            const balanceOfAccount0 = await antTokenInstance.balanceOf(accounts[0]);
            // Assert the correct balance is returned
            assert.equal(balanceOfAccount0, 0, "Should return the balance of accounts[0] as 2");
        });
    });

    describe("ownerOf", () => {
        it("should return the owner of the specified ant", async () => {
            // Deploying a new ant for the test
            await antTokenInstance.createRandomAnt("TestAnt", { from: accounts[0] });

            // Getting the owner of the ant
            const ownerOfAnt = await antTokenInstance.ownerOf(0);

            // Assert the correct owner is returned
            assert.equal(ownerOfAnt, accounts[0], "Should return the owner of the ant as accounts[0]");
        });
    });

    // describe("transferFrom", () => {
    //     it("should transfer ownership of the specified ant from one owner to another", async () => {
    //         await antTokenInstance.transferFrom(accounts[0], accounts[1], 0, { from: accounts[0] });

    //         // Getting the new owner of the ant
    //         const newOwner = await antTokenInstance.ownerOf(0);

    //         // Assert the correct owner is returned
    //         assert.equal(newOwner, accounts[1], "Should transfer ownership of the ant to accounts[1]");
    //     });
    // });
});
