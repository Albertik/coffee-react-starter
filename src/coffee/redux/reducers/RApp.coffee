clone = (o)->
  _.extend({}, o, {version: Math.random()})

module.exports = (state = {status: 'inactive'}, action)->
  if action.type == "SOME_ACTION"
    state.status = action.payload
    clone state
  else
    state