import React from "react";

function Choice(props) {
  return (
    <button className="Choice" left={props.x} onClick={props.onClick}>
      {props.name}
    </button>
  );
}

export function Choices(props) {
  const names = props.names;

  if (names.length < 1) return <div />;

  if (names.length < 2)
    return (
      <div className="Choices">
        <Choice name={names[0]} />
      </div>
    );

  const left = names[0];
  const right = names[1];

  return (
    <div className="Choices">
      <Choice name={left} onClick={() => props.onClick(0)} />
      vs
      <Choice name={right} onClick={() => props.onClick(1)} />
    </div>
  );
}
