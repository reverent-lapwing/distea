import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import Distiea from './App'
import registerServiceWorker from './registerServiceWorker';

const NAMES = [
  "a", "b", "c", "d", "e", "f", "g", "h"  
]

ReactDOM.render(<Distiea names={NAMES}/>, document.getElementById('root'));
registerServiceWorker();
