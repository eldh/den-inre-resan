Breakpoints = require('../../../app/bower_components/js-breakpoints/breakpoints')
_ = require 'lodash'

module.exports =
	_addScreenSize: (screenSize) ->
		newMatchedSizes = _.union @state.matchedScreenSizes, [screenSize]
		if @isMounted() then @setState {matchedScreenSizes: newMatchedSizes}

	_removeScreenSize: (screenSize) ->
		newMatchedSizes = _.without @state.matchedScreenSizes, screenSize
		if @isMounted() then @setState {matchedScreenSizes: newMatchedSizes}

	_addBreakpoint: (name) ->
		window.Breakpoints.on
			name: "media-query-#{name}"
			matched: () => @_addScreenSize name
			exit: () => @_removeScreenSize name

	getInitialState: ->
		matchedScreenSizes: []

	screenWidth: (breakpoints) ->
		for breakpoint in breakpoints
			return true if @isMounted() and @state.matchedScreenSizes.indexOf(breakpoint) isnt -1
		false

	componentDidMount: ->
		_.each ['palm', 'lap', 'lap-and-up', 'portable', 'desk', 'desk-wide'], @_addBreakpoint
