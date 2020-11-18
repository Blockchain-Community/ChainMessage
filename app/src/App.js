import React, { useEffect, useState } from "react";
import Web3 from "web3";
import { createAlchemyWeb3 } from "@alch/alchemy-web3";
import contract from "./build/contracts/CryptoMessage.json";

function App() {
  // by default the account and chainMessage are empty
  const [account, setAccount] = useState("");
  const [chainMessage, setChainMessage] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // load your wallet to the app
    (async function loadWeb3() {
      if (account === "") {
        var { ethereum, web3 } = window;

        if (ethereum) {
          await ethereum.request({ method: "eth_requestAccounts" });
          ethereum.autoRefreshOnNetworkChange = false;
        } else if (web3) {
          web3 = new Web3(web3.currentProvider);
        } else {
          window.alert(
            "Consider using metamask or web3 compatible browser(Mist)."
          );
        }

        // get ethereum accounts
        ethereum
          .request({ method: "eth_accounts" })
          .then((res) => setAccount(res[0]));
      }
    })();

    // load your contract method accessor
    (async function loadContract() {
      if (chainMessage === null) {
        // import credentials from environment file
        const { REACT_APP_CONTRACT_ADDRESS, REACT_APP_API_KEY } = process.env;

        // setting web3 http provider
        const alchWeb3 = createAlchemyWeb3(REACT_APP_API_KEY);

        // initialize contract
        const ethContract = new alchWeb3.eth.Contract(
          contract.abi,
          REACT_APP_CONTRACT_ADDRESS
        );

        setChainMessage(ethContract);
        setLoading(false);
      }
    })();
  });

  return (
    <div>
      {loading ? <h1>Loading...</h1> : <h1>Hello, ChainMessage User🚀</h1>}
    </div>
  );
}

export default App;
