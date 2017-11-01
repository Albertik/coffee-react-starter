{ combineReducers, applyMiddleware, createStore } = require 'redux'
#createHashHistory = require 'history/lib/createHashHistory'
{ syncHistoryWithStore, routerReducer, routerMiddleware } = require 'react-router-redux'
{ devToolsEnhancer } = require 'redux-devtools-extension'
{ filterActions } = require 'redux-ignore'

RApp = require './reducers/RApp'

rlist =
  app: filterActions RApp, ['SOME_ACTION']

#appHistory = useRouterHistory(createHashHistory)({ queryKey: false })
#routerMiddleware = routerMiddleware(appHistory)


reducers = combineReducers(_.extend({}, rlist, {routing: routerReducer}))
#middleware = applyMiddleware(routerMiddleware)

if process?.env?.NODE_ENV == 'production'
  store = createStore(reducers)
else
  store = createStore(reducers, devToolsEnhancer())
  if module.hot
    module.hot.accept rlist, () =>
      store.replaceReducer(reducers)


#syncTranslationWithStore(store)

#history = syncHistoryWithStore(appHistory, store)


exports.store = store
