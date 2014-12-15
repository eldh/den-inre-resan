exports.init = (gulp, logExit, logContinue, target, fileserver) ->
	template = require 'gulp-template'
	rename = require 'gulp-rename'
	del = require 'del'
	runSequence = require 'run-sequence'
	gutil = require 'gulp-util'
	webpack = require 'webpack'
	webpackConfig = require '../webpack.config.js'
	CordovaPlugin = require 'webpack-cordova-plugin'
	cordovaTarget = 'www'

	gulp.task '_dist', (done) ->
		runSequence [
			'_clean-dist'
			'_clean-cordova'
			'_dist-styles'
		], [
			'_dist-index-html'
			'_dist-resources'
			'webpack:dist'
			'_cordova-index-html'
			'webpack:cordova'
		], done

	gulp.task '_dist-server', (done) ->
		fileserver.dist 'dist'

	gulp.task "webpack:dist", (done) ->
		# modify some webpack config options
		distConfigParams = {}

		distConfigParams.entry = {
			main: ['./src/scripts/main.coffee']
		}

		distConfigParams.output = {
			path: target
		}

		distConfigParams.resolve = {
			alias: {
				'config/config-file': '../../resources/dist/config'
			}
		}

		distConfigParams.plugins = [
			new webpack.DefinePlugin({
				"process.env":
					# This has effect on the react lib size
					"NODE_ENV": JSON.stringify("production")

			}),
			new webpack.optimize.DedupePlugin(),
			new webpack.optimize.UglifyJsPlugin({
				mangle: false
			})
		]

		distConfig = webpackConfig(distConfigParams)

		# run webpack
		webpack distConfig, (err, stats) ->
			if (err) then throw new gutil.PluginError("webpack:build", err)

			gutil.log("[webpack:build]", stats.toString(
				colors: true
			))

			done()

	gulp.task "webpack:cordova", (done) ->
		# modify some webpack config options
		cordovaConfigParams = {}

		cordovaConfigParams.entry = {
			main: ['./src/scripts/main.coffee']
		}

		cordovaConfigParams.output = {
			path: cordovaTarget
		}

		cordovaConfigParams.resolve = {
			alias: {
				'config/config-file': '../../resources/cordova/config'
			}
		}

		cordovaConfigParams.plugins = [
			new webpack.DefinePlugin
				"process.env":
					"NODE_ENV": JSON.stringify("production")
			new webpack.optimize.OccurenceOrderPlugin()
			new webpack.optimize.DedupePlugin()
			new webpack.optimize.UglifyJsPlugin mangle: true
			new CordovaPlugin
				config: 'config.xml'
				src: 'index.html'
				platform: 'ios'
				version: true
		]

		cordovaConfig = webpackConfig(cordovaConfigParams)

		# run webpack
		webpack cordovaConfig, (err, stats) ->
			if (err) then throw new gutil.PluginError("webpack:build", err)

			gutil.log("[webpack:build]", stats.toString(
				colors: true
			))

			done()
	
	gulp.task "_dist-index-html", ->
		return gulp.src "src/index.production.html"
			.pipe rename "index.html"
			.pipe gulp.dest target

	gulp.task "_cordova-index-html", ->
		return gulp.src "src/index.cordova.html"
			.pipe rename "index.html"
			.pipe gulp.dest cordovaTarget

	gulp.task "_clean-dist", (cb) ->
		del ['./dist'], cb
	gulp.task "_clean-cordova", (cb) ->
		del ['./www'], cb
