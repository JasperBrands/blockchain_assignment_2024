let antBattleABI;
let antBattleAddress;

let antFactoryABI;
let antFactoryAddress;

let antTokenABI;
let antTokenAddress;

let victoryTokenABI;
let victoryTokenAddress;

let userAddress = "0x796278d73b2bC7a821b88Fbab3343117aD7c1a26";

let allAnts;
let userAnts;
let nonUserAnts;

const Species = {
  0: 'FireAnt',
  1: 'BlackCrazyAnt',
  2: 'CarpenterAnt'
};
const SpeciesImages = {
  FireAnt: 'https://media.wired.com/photos/5c1d2fde36da29336938e319/master/w_1920,c_limit/fireant-686792679.jpg',
  BlackCrazyAnt: 'https://smarterpestcontrol.com/wp-content/uploads/2018/07/crazy-ants.jpg',
  CarpenterAnt: 'https://www.southernliving.com/thmb/nKg03ytfQ9oS3uThP9EwQdQaa_Q=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/1435184-LGPT-b43ac09e092842239a6ea328251d7764.jpg'
};

fetch('../build/contracts/AntBattle.json')
  .then(response => response.json())
  .then(data => {
    antBattleABI = data.abi;
    antBattleAddress = data.networks[5777].address;

    // Fetch additional JSON files
    return Promise.all([
      fetch('../build/contracts/AntFactory.json').then(response => response.json()),
      fetch('../build/contracts/AntToken.json').then(response => response.json()),
      fetch('../build/contracts/VictoryToken.json').then(response => response.json())
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

    // console.log(antTokenABI, antTokenAddress, antFactoryABI, antFactoryAddress, antBattleABI, antBattleAddress, victoryTokenABI, victoryTokenAddress);

    // Initialize Web3 with Ganache HTTP provider
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:7545'));

    // Initialize contracts
    const antBattleContract = new web3.eth.Contract(antBattleABI, antBattleAddress);
    const antFactoryContract = new web3.eth.Contract(antFactoryABI, antFactoryAddress);
    const antTokenContract = new web3.eth.Contract(antTokenABI, antTokenAddress);
    const victoryTokenContract = new web3.eth.Contract(victoryTokenABI, victoryTokenAddress);

    document.getElementById('getNewAnt').onsubmit = async (e) => {
      e.preventDefault();
      const antName = document.getElementById('antName').value;

      try {
          console.log('Generating DNA for:', antName);
          await antFactoryContract.methods.createRandomAnt(antName).send({ from: userAddress, gas: 200000 });
          console.log('Generated ant:');
          document.getElementById('status').innerText = `Generated new Ant`;

          getUserAnts();
          getEnemyAnts();

      } catch (error) {
          console.error('Error generating ant:', error);
          document.getElementById('status').innerText = error.message;
      }
    };

    const getUserAnts = async () => {
        try {
            userAnts = await antFactoryContract.methods.getAntsByOwner(userAddress).call({ from: userAddress });
            console.log('User Ants:', userAnts);
            displayAnts(userAnts, 'antsContainer');
            getEnemyAnts();
        } catch (error) {
            console.error('Error fetching user ants:', error);
        }
    };

    const getEnemyAnts = async () => {
      try {
        allAnts = await antFactoryContract.methods.getAnts().call();
        nonUserAnts = allAnts.filter(ant => !userAnts.some(userAnt => userAnt.dna === ant.dna));
        console.log('Non-user Ants:', nonUserAnts);
        displayAnts(nonUserAnts, 'enemyAntsContainer');

        populateDropdowns();


      } catch (error) {
          console.error('Error fetching ants:', error);
      }
    };

    const displayAnts = (ants, ElementId) => {
      const antsContainer = document.getElementById(ElementId);
      antsContainer.innerHTML = '';
      ants.forEach(ant => {
        const speciesName = Species[ant.species];
        const antImage = SpeciesImages[speciesName];
        const antElement = document.createElement('div');
        antElement.classList.add('ant');
        antElement.innerHTML = `
          <h2>${ant.name}</h2>
          <p>DNA: ${ant.dna}</p>
          <p>Species: ${speciesName}</p>
          <p>Win Count: ${ant.winCount}</p>
          <p>Loss Count: ${ant.lossCount}</p>
          <img src="${antImage}" alt="${ant.name}" style="width: 200px; height: 200px;" />
        `;
        antsContainer.appendChild(antElement);
      });
    };


    // Event listener for buying a new ant
    document.getElementById('buyNewAnt').onsubmit = async (e) => {
      e.preventDefault();
      const antName = document.getElementById('buyAntName').value;
      const chosenSpecies = document.getElementById('speciesDropdown').value;

      try {
        await antFactoryContract.methods.buyAntByChoice(antName, chosenSpecies).send({ from: userAddress, gas: 200000 });
        console.log('Generated ant:');
        document.getElementById('buyStatus').innerText = `Bought new Ant`;

        getUserAnts();
        getEnemyAnts();

      } catch (error) {
        console.error('Error generating ant:', error);
        document.getElementById('buyStatus').innerText = error.message;
      }
    };

    getUserAnts();

    const victoryToken = async () => {
      try {
        // await victoryTokenContract.methods._mintVictoryTokens(userAddress, 3).send({ from: userAddress });
        const tokenCount = await victoryTokenContract.methods.tokenCount(userAddress).call({ from: userAddress });

        const tokenContainer = document.getElementById('victoryTokenCounter');
        tokenContainer.innerHTML = `<p>Victory Tokens: ${tokenCount}</p>`;
      } catch (error) {
        console.error(error);
      }
    };
  
    victoryToken();

    const populateAntDropdowns = (ants, dropdownId) => {
      const dropdown = document.getElementById(dropdownId);
      dropdown.innerHTML = '<option value="" selected>Select ant</option>';
      ants.forEach(ant => {
        const option = document.createElement('option');
        option.value = ant.dna;
        option.textContent = ant.name;
        dropdown.appendChild(option);
      });
    };
    
    const populateDropdowns = () => {
      populateAntDropdowns(userAnts, 'firstAnt');
      populateAntDropdowns(nonUserAnts, 'secondAnt');
    };
    
    document.getElementById('battleForm').onsubmit = async (e) => {
      e.preventDefault();
      const firstAntDna = document.getElementById('firstAnt').value;
      const secondAntDna = document.getElementById('secondAnt').value;
      try {
        // const firstAndid = await antFactoryContract.methods.getAntId(firstAntDna).call({ from: userAddress })
        // const secondAndid = await antFactoryContract.methods.getAntId(secondAntDna).call({ from: userAddress })

        // console.log(firstAndid)
        // console.log(await antFactoryContract.methods.getAntOwner(firstAndid).call({ from: userAddress }))

        const result = await antBattleContract.methods.attack(firstAntDna, secondAntDna).send({ from: userAddress, gas: 200000 });
        console.log(result);
        document.getElementById('battleStatus').innerText = 'Battle started successfully';
      } catch (error) {
        console.error('Error starting battle:', error);
        document.getElementById('battleStatus').innerText = 'Error: ' + error.message;
      }
    };

    
    console.log(antFactoryContract.methods)
    console.log(victoryTokenContract.methods)

  })
  .catch(error => {
    console.error('Error fetching JSON:', error);
  });