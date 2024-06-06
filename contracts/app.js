let antBattleABI;
let antBattleAddress;

let antFactoryABI;
let antFactoryAddress;

let antTokenABI;
let antTokenAddress;

let victoryTokenABI;
let victoryTokenAddress;

let userAddress = "0x25748Ed68e108667cDA7B55Dd80394C9f4574e31";

// Define variables for additional JSON files
fetch('http://127.0.0.1:5500/build/contracts/AntBattle.json')
  .then(response => response.json())
  .then(data => {
    antBattleABI = data.abi;
    antBattleAddress = data.networks[5777].address;

    // Fetch additional JSON files
    return Promise.all([
      fetch('http://127.0.0.1:5500/build/contracts/AntFactory.json').then(response => response.json()),
      fetch('http://127.0.0.1:5500/build/contracts/AntToken.json').then(response => response.json()),
      fetch('http://127.0.0.1:5500/build/contracts/VictoryToken.json').then(response => response.json())
    ]);
  })
  .then(jsonDataArray => {
    // Handle each JSON data separately
    antFactoryABI = jsonDataArray[0].abi;
    antFactoryAddress = jsonDataArray[0].networks[5777].address;

    antTokenABI = jsonDataArray[1].abi;
    antTokenAddress = jsonDataArray[1].networks[5777].address;

    victoryTokenABI = jsonDataArray[2].abi;
    victoryTokenAddress = jsonDataArray[2].networks[5777].address;

    console.log(antTokenABI, antTokenAddress, antFactoryABI, antFactoryAddress, antBattleABI, antBattleAddress, victoryTokenABI, victoryTokenAddress);

    // Initialize Web3 with Ganache HTTP provider
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545')); // Ensure Ganache is running on this port

    // Initialize contracts
    const antBattleContract = new web3.eth.Contract(antBattleABI, antBattleAddress);
    const antFactoryContract = new web3.eth.Contract(antFactoryABI, antFactoryAddress);
    const antTokenContract = new web3.eth.Contract(antTokenABI, antTokenAddress);
    const victoryTokenContract = new web3.eth.Contract(victoryTokenABI, victoryTokenAddress);

    // Event listener for creating a new ant
    document.getElementById('getNewAnt').onsubmit = async (e) => {
        e.preventDefault();
        const antName = document.getElementById('antName').value;

        try {
            console.log('Generating DNA for:', antName);
            await antFactoryContract.methods.createRandomAnt(antName).send({ from: userAddress, gas: 200000 });
            console.log('Generated ant:');
            document.getElementById('status').innerText = `Generated new Ant`;

            getUserAnts();

        } catch (error) {
            console.error('Error generating ant:', error);
            document.getElementById('status').innerText = 'Error generating Ant';
        }
    };

    // Function to fetch and log user's ants
    const getUserAnts = async () => {
        try {
            const ants = await antBattleContract.methods.getAntsByOwner(userAddress).call({ from: userAddress });
            console.log('User Ants:', ants);
        } catch (error) {
            console.error('Error fetching user ants:', error);
        }
    };

    const getAllAnts = async () => {
        try {
            const ants = await antBattleContract.methods.ownerAntCount(userAddress).call({ from: userAddress });
            console.log('Ants:', ants);
        } catch (error) {
            console.error('Error fetching ants:', error);
        }
    };

    console.log(antBattleContract.methods)

    // Call the function to fetch and show user's ants
    getUserAnts();
    getAllAnts();

  })
  .catch(error => {
    console.error('Error fetching JSON:', error);
  });