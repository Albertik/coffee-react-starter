{connect} = require 'react-redux'
{ withRouter } = require 'react-router'

module.exports = (reactClass, f)->
  withRouter connect(
    f?.state || ()-> {}
    f?.dispatch || ()-> {}
  )(reactClass)
