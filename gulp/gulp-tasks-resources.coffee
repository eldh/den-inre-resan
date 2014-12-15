COMMON_PATH = 'src/resources/common/**/*'
APP_PATH = 'app/'

copyResources = (gulp, destination) ->
	gulp.src COMMON_PATH
		.pipe gulp.dest destination

exports.init = (gulp, logExit, logContinue, target, skipWatch) ->
	gulp.task "_dist-resources", ->
		copyResources(gulp, target)

	gulp.task "_resources", ->
		copyResources(gulp, APP_PATH)

	gulp.task "_watch-resources", ['_resources'], ->
		gulp.watch COMMON_PATH, ['_resources']

	gulp.task "_index-html", ->
		gulp.src "src/index.html"
			.pipe gulp.dest APP_PATH
