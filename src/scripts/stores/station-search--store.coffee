Reflux = require 'reflux'
Actions = require '../actions/station-search--actions'
Api = require '../api/station-search--api'
Config = require '../config/config'
_ = require 'lodash'

module.exports = Reflux.createStore

	listenables: Actions

	init: ->
		@throttledRequest	= _.debounce @makeRequest, 500
		@data =
			syncing: false
			stations: []

	getDefaultData: ->
		@data

	onClear: (data) ->
		@data = 
			stations: undefined
		@trigger @data

	onSearchStation: (data) ->
		data = 
			searchstring: data
		@throttledRequest data, 'searchStation', _.bind(@onSearchStationDone, this), false
		@data.syncing = true
		@trigger @data

	makeRequest: (data, method, callback) ->
		Api[method] data, callback, false

	onSearchStationDone: (response) ->
		@data.stations = response.ResponseData
		@data.syncing = false
		@trigger @data
