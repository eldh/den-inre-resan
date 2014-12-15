portfinder = require "portfinder"
express = require 'express'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
webpackConfig = require './webpack.config'
http = require 'http'

servers = []

expandPath = (app, appPath) ->
	app.use(express.static(appPath))
	app.set('views', __dirname + '/' + appPath)
	app.engine('html', require('ejs').renderFile)
	app.get('*', (req, res, next) ->
		url = req.url
		isFile = url.substring(url.lastIndexOf('/') + 1).indexOf('.') > -1	# the last section after '/' contains a dot, assume it has a file ending

		if isFile
			next()
		else
			res.render('index.html')

	)

APIServer = (port, options) ->
	apiPort = port + 5
	api = express()

	api.all '*', (req, res, next) ->
		res.set('Access-Control-Allow-Origin', req.headers.origin)
		res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Content-Length, Accept, Origin')
		res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE')
		res.set('Access-Control-Allow-Credentials', 'true')
		res.set('Access-Control-Max-Age', 5184000)
		next()



	api.listen apiPort

DevServer = (port, appPath) ->
	devConfigParams = {}
	devConfigParams.entry = {
		main: [
			'webpack-dev-server/client?http://localhost:8000',
			'webpack/hot/dev-server',
			'./src/scripts/main.coffee'
		]
	}

	devConfigParams.plugins = [
		new webpack.HotModuleReplacementPlugin()
	]

	devConfigParams.devtool = "eval"	# not working with FastClick until https://github.com/ftlabs/fastclick/pull/270 is resolved
	# devConfigParams.devtool = "source-map"	# see if we can manage without this as well, will speed up the build a lot
	devConfigParams.debug = true

	devConfig = webpackConfig(devConfigParams)

	server = new WebpackDevServer(webpack(devConfig), {
		contentBase: 'app'
		hot: true
		stats: {
			hash: false
			version: false
			assets: false
			cached: false
			colors: true
		}
	})

	expandPath(server.app, appPath)

	server.listen port, (err, result) ->
		if (err)
			console.log(err);

		console.log('Listening at port ' + port);

	server

SimpleServer = (port, appPath) ->
	app = new express()

	expandPath(app, appPath)

	server = http.createServer app
	server.listen port

	return server

# dev server
exports.dev = (appPath) ->
	portfinder.getPort (err, port) ->
		servers.push(
			# APIServer(port, {})
			DevServer(port, appPath)
		)
# dist server
exports.dist = (appPath) ->
	portfinder.getPort (err, port) ->
		servers.push(
			SimpleServer(port, appPath)
		)

		console.log('Listening at port ' + port);

# used for integration tests
exports.test = (appPath, started, options) ->
	portfinder.getPort (err, port) ->
		servers.push(
			# APIServer(port, options)
			SimpleServer(port, appPath)
		)

		started("http://localhost:" + port);

exports.stop = ->
	servers.forEach (server) ->
		server.close()
