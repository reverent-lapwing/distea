import React, { Component } from 'react';
import './App.css';

class Item extends Component {
  
  handleChange = (event) => {
    this.props.onChange(event.target.value)
  }

  render() {
    return (
      <li>
        <input type="text" value={this.props.name} onChange={this.handleChange}/>
      </li>
    )
  }
}

function List(props) {
  const names = props.names;
  const items = names.map((name, i) =>
    <Item name={name} onChange={name => props.onChange(i, name)}/>
  );
  
  return (
    <div className="ChoiceList">
      <ul>{items}</ul>
    </div>
  );
}

class NewEntry extends Component {
  constructor (props) {
    super(props)
    this.state = {
      value : "",
      
    }

    this.onSubmit = props.onSubmit
    
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)
  }
  
  handleChange(event) {
    this.setState({
      value : event.target.value
    })
  }

  handleSubmit(event) {
    event.preventDefault()
    this.onSubmit(this.state.value)
    this.setState({value : ""})
  }

  render () {
    return (
      <form onSubmit={this.handleSubmit}>
        <input type="text" value={this.state.value} onChange={this.handleChange}/>
      </form>
    )
  }
}

function Entries(props)  {
  const names = props.names;

  return (
    <div className="Entries">
      <NewEntry onSubmit={props.onSubmit}/>
      <List names={names} onChange={props.onChange}/>
      <button onClick={props.onStart}>Start</button>
    </div>
  );
}

function Choice(props) {
  return (
    <button className="Choice" left={props.x} onClick={props.onClick}>
      {props.name}
    </button>
  )
}

function Choices(props) {
  const names = props.names

  if(names.length < 1)
    return <div/>
  
  if(names.length < 2)
    return (
      <div className="Choices">
        <Choice name={names[0]}/>
      </div>
    )
  
  const left = names[0]
  const right = names[1]

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
      names : [],
      started : false
    };

    this.addEntry = this.addEntry.bind(this)
    this.editEntry = this.editEntry.bind(this)
    this.start = this.start.bind(this)
    this.pop = this.pop.bind(this)
  }

  render() {
    const names = this.state.names.slice()

    const content = !this.state.started ? (
      <Entries names={names} onSubmit={this.addEntry} onChange={this.editEntry} onStart={this.start}/>
    ) : (
      <Choices names={names} onClick={this.pop}/>
    )

    return (
      <div className="Dashboard">
        {content}      
      </div>
    )
  }

  editEntry (i, name) {
    var names = this.state.names.slice()
    names.splice(i, 1, name)

    this.setState({
      names : names
    }) 
  }

  addEntry (name) {
    const names = this.state.names
    
    this.setState({
      names : names.concat([name]) 
    })
  }
  
  start () {
    this.setState({started : true})
  }

  pop(i) {
    const names = this.state.names
    const first = names[0]
    const second = names[1]
    const tail = names.slice(2, this.state.names.length);

    const newNames = (i === 0) ? tail.concat([first]) : tail.concat([second])

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
