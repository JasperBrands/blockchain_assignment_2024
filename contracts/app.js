// Initialize Web3
if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    window.ethereum.enable();
} else {
    console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
}

const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [
    // Your contract ABI goes here
];

const antTokenContract = new web3.eth.Contract(contractABI, contractAddress);

document.getElementById('mintForm').onsubmit = async (e) => {
    e.preventDefault();

    const antName = document.getElementById('antName').value;
    const tokenURI = document.getElementById('tokenURI').value;

    const accounts = await web3.eth.getAccounts();
    const account = accounts[0];

    try {
        const result = await antTokenContract.methods.createRandomAnt(antName, tokenURI).send({ from: account });
        document.getElementById('status').innerText = 'Ant Token minted successfully!';
        console.log(result);
    } catch (error) {
        console.error(error);
        document.getElementById('status').innerText = 'Error minting Ant Token';
    }
};
