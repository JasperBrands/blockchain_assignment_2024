const AntFactory = artifacts.require("AntFactory");
const VictoryToken = artifacts.require("VictoryToken");

contract("AntFactory", (accounts) => {
    let antFactoryInstance;
    let victoryTokenInstance;

    before(async () => {
        antFactoryInstance = await AntFactory.deployed();
        victoryTokenInstance = await VictoryToken.deployed();
    });

    it("should create a new ant", async () => {
        const antName = "TestAnt";
        await antFactoryInstance.createRandomAnt(antName, { from: accounts[0] });
        const ants = await antFactoryInstance.getAnts();
        assert.equal(ants.length, 1, "Ant not created successfully");
    });

    it("should not create a new ant if the user already owns one", async () => {
        const antName = "SecondAnt";
        try {
            await antFactoryInstance.createRandomAnt(antName, { from: accounts[0] });
            assert.fail("Should have reverted");
        } catch (error) {
            assert(error.message.includes("You already own an ant"), "Incorrect revert reason");
        }
    });

    it("should buy a new ant by choice", async () => {
        const antName = "TestAnt";
        const Species = { FireAnt: 0, BlackCrazyAnt: 1, CarpenterAnt: 2 };
        await victoryTokenInstance._mintVictoryTokens(accounts[0], 100);

        // Getting the balance of accounts[0]
        const balanceOfAccount0 = await victoryTokenInstance.getTokenCount(accounts[0]);


        console.log("--------------------------------------------", balanceOfAccount0);

        

        await antFactoryInstance.buyAntByChoice(antName, Species.FireAnt, { from: accounts[0] });
        const ants = await antFactoryInstance.getAnts();
        assert.equal(ants.length, 2, "Ant not bought successfully");
    });

    it("should not buy a new ant by choice if the user doesn't own any ant", async () => {
        const antName = "AnotherAnt";
        const Species = { FireAnt: 0, BlackCrazyAnt: 1, CarpenterAnt: 2 };
        try {
            await antFactoryInstance.buyAntByChoice(antName, Species.FireAnt, { from: accounts[1] });
            assert.fail("Should have reverted");
        } catch (error) {
            assert(error.message.includes("You must own at least one ant"), "Incorrect revert reason");
        }
    });

    it("should not buy a new ant by choice if the user has insufficient VictoryTokens", async () => {
        const antName = "AnotherAnt";
        const Species = { FireAnt: 0, BlackCrazyAnt: 1, CarpenterAnt: 2 };
        await antFactoryInstance.createRandomAnt(antName, { from: accounts[1] });
        await victoryTokenInstance._mintVictoryTokens(accounts[1], 1);
        try {
            await antFactoryInstance.buyAntByChoice(antName, Species.FireAnt, { from: accounts[1] });
            assert.fail("Should have reverted");
        } catch (error) {
            assert(error.message.includes("Insufficient VictoryTokens"), "Incorrect revert reason");
        }
    });
});