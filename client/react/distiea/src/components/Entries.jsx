import React, { Component } from "react";

class Item extends Component {
  handleChange = event => {
    this.props.onChange(event.target.value);
  };

  render() {
    return (
      <li>
        <input
          type="text"
          value={this.props.name}
          onChange={this.handleChange}
        />
      </li>
    );
  }
}

function List(props) {
  const names = props.names;
  const items = names.map((name, i) => (
    <Item name={name} onChange={name => props.onChange(i, name)} />
  ));

  return (
    <div className="ChoiceList">
      <ul>{items}</ul>
    </div>
  );
}

class NewEntry extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: ""
    };

    this.onSubmit = props.onSubmit;

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    this.setState({
      value: event.target.value
    });
  }

  handleSubmit(event) {
    event.preventDefault();
    this.onSubmit(this.state.value);
    this.setState({ value: "" });
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type="text"
          value={this.state.value}
          onChange={this.handleChange}
        />
      </form>
    );
  }
}

export function Entries(props) {
  const names = props.names;

  return (
    <div className="Entries">
      <NewEntry onSubmit={props.onSubmit} />
      <List names={names} onChange={props.onChange} />
      <button onClick={props.onStart}>Start</button>
    </div>
  );
}
