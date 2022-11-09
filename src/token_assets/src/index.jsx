import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
// import { AuthClient } from "@dfinity/auth-client";

const init = async () => { 

  // logging in the user
  // const authClient = await AuthClient.create();

  // the link is the identity provider on the Internet Computer
  // basically provides the front end for log in purposes
  // await authClient.login({
  //   identityProvider: "http://identity.ic0.app/#authorize",
  //   onSuccess: () => {
      ReactDOM.render(<App />, document.getElementById("root"));
  //   }
  // });

}

init();


