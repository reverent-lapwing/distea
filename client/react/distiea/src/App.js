import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

function List(props) {
  return (
    <div className="ChoiceList">
      <ul>
        <li>Item 1</li>
      </ul>
    </div>
  );
}

class App extends Component {
  render() {
    const style = { x : 200, width : '150px', overflow : 'hidden' }
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <div style={style}>
            <h1 className="App-title">Welcome to React</h1>
          </div>
        </header>
        <List/>
      </div>
    );
  }
}

export default App;
