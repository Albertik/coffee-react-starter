{ render } = require 'react-dom';
{ Provider } = require 'react-redux'

import { BrowserRouter as Router, Route } from 'react-router-dom'
{ browserHistory } = require 'react-router'
{ store } = require './redux/Store'

startApp = ()->
  render(
    <Provider store={store}>
      <Router history={browserHistory}>
        <Route exact path='/' component={require './pages/Home'} />
      </Router>
    </Provider>
    document.querySelector(".wrapper")
  )

startApp()