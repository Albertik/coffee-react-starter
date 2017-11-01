path = require 'path'
merge = require 'webpack-merge'
webpack = require 'webpack'
CleanWebpackPlugin = require 'clean-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'

PATHS =
  app: path.join(__dirname, 'src/coffee', 'App.cjsx')
  build: path.join(__dirname, 'build')
  favicon: path.join(__dirname, 'src/assets','favicon.ico')

parts =
  devServer: (options) ->
    watchOptions:
      aggregateTimeout: 300
      poll: 1000
    devServer:
      historyApiFallback: true
      hot: true
      inline: true
      stats: 'errors-only'
      host: options.host
      port: options.port || 8889
    plugins: [
      new (webpack.HotModuleReplacementPlugin)()
    ]

  indexTemplate: (options)->
    plugins: [
      new HtmlWebpackPlugin
        template: 'src/index.html'
        title: options.title
        appMountId: options.appMountId
        baseHref: options.baseHref
        inject: false
    ]

  extractBundle: (options) ->
    entry = {}
    entry[options.name] = options.entries
    entry: entry
    plugins: [ new (webpack.optimize.CommonsChunkPlugin)(
      names: [
        options.name
        'manifest'
      ]
      minChunks: Infinity)
    ]

  loadCJSX: () ->
    module:
      rules: [
        { test: /\.cjsx$/, use: ['react-hot-loader/webpack', 'coffee-loader', 'cjsx-loader']},
        { test: /\.coffee$/, use: ['coffee-loader'] }
      ]

  clean: (path) ->
    plugins: [
      new CleanWebpackPlugin([ path ], root: process.cwd())
    ]

  setGlobalVariable: (env) ->
    plugins: [
      new (webpack.ProvidePlugin)(env)
    ]

common = merge
  entry:
    app: PATHS.app
  output:
    path: PATHS.build
    filename: '[name].js'
    publicPath: '/'
  resolve:
    extensions: ['.js', '.cjsx', '.coffee']

  parts.indexTemplate
    title: 'title'
    appMountId: 'wrapper'
  parts.setGlobalVariable
    React: 'react'
    createReactClass: 'create-react-class'
    _: 'lodash'
  parts.loadCJSX()

switch process.env.npm_lifecycle_event
  when 'build','build-prod','build-test', 'stats'
    config = merge common,
      output:
        path: PATHS.build,
        filename: 'scripts/[name].[chunkhash].js'
        chunkFilename: 'scripts/[chunkhash].js'
      parts.clean(PATHS.build)
      parts.extractBundle
        name: 'vendor'
        entries: [
          'react', 'redux', 'react-redux', 'react-router-redux'
        ]

  else
    config = merge common,
      devtool: 'source-map'
      parts.devServer
        host: process.env.HOST
        port: process.env.PORT
        poll: process.env.ENABLE_POLLING

module.exports = config

