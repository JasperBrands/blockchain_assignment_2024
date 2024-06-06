// AntBattle.test.js
const AntBattle = artifacts.require("AntBattle");
const VictoryToken = artifacts.require("VictoryToken");
const AntFactory = artifacts.require("AntFactory");

contract("AntBattle", (accounts) => {
    let antBattleInstance;
    let victoryTokenInstance;
    let antFactoryInstance;

    before(async () => {
        antFactoryInstance = await AntFactory.deployed();
        antBattleInstance = await AntBattle.deployed();
        victoryTokenInstance = await VictoryToken.deployed();
    });

    describe("attack", () => {
        it("should allow an ant to attack another ant", async () => {
            // Deploying two ants for the test
            await antBattleInstance.createRandomAnt("AttackingAnt", { from: accounts[0] });
            await antBattleInstance.createRandomAnt("TargetAnt", { from: accounts[1] });

            // Performing the attack
            const result = await antBattleInstance.attack(0, 1, { from: accounts[0] });

            // Assert the outcome of the attack
        });
    });

    before(async () => {
        antBattleInstance = await AntBattle.deployed();
    });

    // describe("getAntOwner", () => {
    //     it("should return the owner of the specified ant", async () => {
    //         // Deploying a new ant for the test
    //         await antBattleInstance.createRandomAnt("TestAnt", { from: accounts[0] });

    //         // Getting the owner of the ant
    //         const owner = await antBattleInstance.getAntOwner(0);

    //         // Assert the owner is correct
    //         assert.equal(owner, accounts[0], "Owner of the ant should be the deploying account");
    //     });
    // });

    describe("getAntsByOwner", () => {
        it("should return an array of ant IDs owned by the specified owner", async () => {
            // Deploying a few ants for the test
            await antFactoryInstance.createRandomAnt("Ant1", { from: accounts[0] });
            await antFactoryInstance.createRandomAnt("Ant3", { from: accounts[1] });

            // Getting the ants owned by accounts[0]
            const antsOwnedByAccount0 = await antBattleInstance.getAntsByOwner(accounts[0]);
            // Assert the correct ants are returned
            assert.equal(antsOwnedByAccount0.length, 1, "Should return one ant owned by accounts[0]");
            // Add more assertions to check if the returned array contains the correct ant IDs
        });
    });
});