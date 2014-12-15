gulp = require('gulp')
util = require('gulp-util')
environmentHelper = require('./gulp/environmentHelper')
fileserver = require('./fileserver.coffee')
target = environmentHelper.get('target', 'dist/')
skipWatch = environmentHelper.get('skipWatch', 'false')
grepFlag = environmentHelper.get('grep', null)
fs = require 'fs'

logExit = (error) ->
	util.log util.colors.red(error)
	process.exit 1
	return

logContinue = (error) ->
	if skipWatch is 'true'
		logExit error
	else
		util.log util.colors.red error
		@emit? 'end'
	return

# Make sure that we have a private-config first.
confFile = 'src/resources/common/private-config.json'
if not fs.existsSync confFile
	fs.writeFileSync confFile, '{}'

require './gulp/gulp-tasks-resources.coffee'
	.init gulp, logExit, logContinue, target, skipWatch

require './gulp/gulp-tasks-styles.coffee'
	.init gulp, logExit, logContinue, target, skipWatch

require './gulp/gulp-tasks-core.coffee'
	.init gulp, logExit, logContinue, fileserver

require './gulp/gulp-tasks-dist.coffee'
	.init gulp, logExit, logContinue, target, fileserver

