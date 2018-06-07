import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';



function Item(props) {
  return <li>{props.value}</li>
} 

function List(props) {
  const names = props.names;
  const items = names.map((name) =>
    <Item value={name}/>
  );
  
  return (
    <div className="ChoiceList">
      {items}
    </div>
  );
}

function Input(props) {
  return <input/>
}

class Entries extends Component  {

  
  render() {
    const names = this.props.names;
  
    return (
      <div className="Entries">
        <Input/>
        <List names={names}/>
      </div>
    );
  }
}

function Choice(props) {
  return (
    <button className="Choice" left={props.x} onClick={props.onClick}>
      {props.name}
    </button>
  )
}

function Choices(props) {
  const left = props.names[0]
  const right = props.names[1]

  return (
    <div className="Choices">
        <Choice name={left} onClick={() => props.onClick(0)}/>
        vs
        <Choice name={right} onClick={() => props.onClick(1)}/>
    </div>
  )
}

class Dashboard extends Component {
  constructor(props) {
    super(props)
    this.state = {
      names : []
    };

    this.state.names = props.names
  }

  render() {
    const names = this.state.names

    return (
      <div className="Dashboard">
        <Entries names={names}/>
        <Choices names={names} onClick={i => this.pop(i)}/>
      </div>
    )
  }

  pop(i) {
    const names = this.state.names
    const first = names[0]
    const second = names[1]
    const tail = names.slice(1, this.state.names.length-2);

    const newNames = i === 0 ? tail.concat([first]) : tail.concat([second])

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
        <Dashboard names={this.props.names}/>
      </div>
    );
  }
}

export default Distiea;
