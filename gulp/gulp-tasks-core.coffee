exports.init = (gulp, logExit, logContinue, fileserver) ->
	gulp = require 'gulp'
	del = require 'del'
	environmentHelper = require './environmentHelper'

	skipWatch = environmentHelper.get 'skipWatch', 'false'
	grepFlag = environmentHelper.get 'grep', null

	gulp.task 'default', ['dev']

	gulp.task 'styles', ['_styles']
	gulp.task 'dist', ['_dist']
	gulp.task 'build-icons', ['_build-icons']

	gulp.task 'dist-server', ['_dist-server']

	gulp.task 'dev', ['_index-html', '_watch-resources'], ->
		return fileserver.dev 'app'

	gulp.task 'clean', (cb) ->
		del ['app/**/*', '!app/bower_components{,/**}', './dist'], cb
