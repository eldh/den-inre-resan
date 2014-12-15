Actions = require '../actions/position--actions'
Reflux = require 'reflux'
Config = require '../config/config'
_ = require 'lodash'

module.exports = Reflux.createStore

	listenables: Actions

	init: ->
		@data =
			position:
				coords:
					latitude: 'dunno'
					longitude: 'dunno'

	onSetPosition: (position) ->
		@data.position = position
		@trigger @data

