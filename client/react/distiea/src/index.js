import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import Distiea from "./components/App";
import registerServiceWorker from "./registerServiceWorker";

ReactDOM.render(<Distiea />, document.getElementById("root"));
registerServiceWorker();
