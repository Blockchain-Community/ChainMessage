const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config()

const { API_KEY, MNEMONIC } = process.env;
module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545, // Ganache GUI & CUI uses diff. port i.e. 7545 or 8545
            network_id: "\*", // Match any network id
            gas: 5000000
        },
        rinkbey: {
            provider: function () {
                return new HDWalletProvider(MNEMONIC, API_KEY)
            },
            network_id: 4
        }
    },
    compilers: {
        solc: {
            settings: {
                optimizer: {
                enabled: true, // Default: false
                runs: 200 // Default: 200
                },
            }
        }
    }
}