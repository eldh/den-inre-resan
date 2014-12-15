exports.init = (gulp, logExit, logContinue, target, skipWatch) ->
	sass = require "gulp-sass"
	plumber = require "gulp-plumber"
	notify = require "gulp-notify"
	prefix = require "gulp-autoprefixer"
	util = require "gulp-util"
	exec = require("child_process").exec
	csso = require "gulp-csso"

	file = "src/styles/main.scss"
	includePaths = ["src/styles/*"]

	gulp.task "_styles", ['_dev-styles', '_hashgrid'], ->
		gulp.watch 'src/styles/**/*.scss', ['_dev-styles', '_hashgrid']
		util.log '**WATCHING STYLES FOLDER**'

	gulp.task "_dev-styles", ->
		gulp.src [file]
			.pipe plumber()
			.pipe sass
				includePaths: includePaths
				# sourceComments: "map" Using this crashes node-sass at the moment (june 9 2014).
			.on "error", logContinue
			.on "error", notify.onError (err) ->
				"Styles error: " + err.message
			.pipe prefix "last 2 versions", "ie 10", "Android 4", {map: false}
			.pipe gulp.dest "src/styles"

	gulp.task "_hashgrid", ->
		gulp.src ["src/styles/hashgrid.scss"]
			.pipe plumber()
			.pipe sass
				includePaths: includePaths
			.on "error", logContinue
			.on "error", notify.onError (err) ->
				"Styles error: " + err.message
			.pipe prefix "last 2 versions", "ie 10", "Android 4", {map: false}
			.pipe gulp.dest "app/css"

	gulp.task "_dist-styles", ->
		gulp.src file
			.pipe sass
				includePaths: includePaths
				outputStyle: "compressed"
				sourceComments: "normal"
			.on "error", logExit
			.pipe prefix "last 2 versions", "ie 10", "Android 4", {map: false}
			.pipe csso()
			.pipe gulp.dest "src/styles"

	gulp.task "_build-icons", (fontsDone) ->
		exec 'cd ../assets/ && fontcustom compile', (error, stdout, stderr) ->
			util.log stdout
			logExit error if error
			fontsDone()
