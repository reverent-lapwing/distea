import React, { Component } from "react";
import "./App.css";
import Entries from "./Entries";
import Choices from "./Choices";

class Dashboard extends Component {
  constructor(props) {
    super(props);
    this.state = {
      names: [],
      started: false
    };

    this.xhr = new XMLHttpRequest();
    this.xhr.open("GET", "https://ipinfo.io/json", true); // replace with distiea server address
    this.xhr.send();

    this.processRequest = this.processRequest.bind(this);

    this.xhr.addEventListener("readystatechange", this.processRequest, false);

    this.addEntry = this.addEntry.bind(this);
    this.editEntry = this.editEntry.bind(this);
    this.start = this.start.bind(this);
    this.pop = this.pop.bind(this);
  }

  processRequest(e) {
    if (this.xhr.readyState !== 4) {
      return;
    }

    if (this.xhr.status !== 200) {
      return;
    }

    const response = JSON.parse(this.xhr.responseText);
    //alert(response.ip)
  }

  render() {
    const names = this.state.names.slice();

    const content = !this.state.started ? (
      <Entries
        names={names}
        onSubmit={this.addEntry}
        onChange={this.editEntry}
        onStart={this.start}
      />
    ) : (
      <Choices names={names} onClick={this.pop} />
    );

    return <div className="Dashboard">{content}</div>;
  }

  editEntry(i, name) {
    var names = this.state.names.slice();
    names.splice(i, 1, name);

    this.setState({
      names: names
    });
  }

  addEntry(name) {
    const names = this.state.names;

    this.setState({
      names: names.concat([name])
    });
  }

  start() {
    this.setState({ started: true });
  }

  pop(i) {
    const names = this.state.names;
    const first = names[0];
    const second = names[1];
    const tail = names.slice(2, this.state.names.length);

    const newNames = i === 0 ? tail.concat([first]) : tail.concat([second]);

    this.setState({
      names: newNames
    });
  }
}

class Distiea extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Distiea</h1>
        </header>
        <Dashboard />
      </div>
    );
  }
}

export default Distiea;
