Reflux = require 'reflux'
Actions = require '../actions/place--actions'
Config = require '../config/config'
_ = require 'lodash'
Tracking = require '../tracking/tracking'

module.exports = Reflux.createStore

	listenables: Actions

	init: ->
		@data = JSON.parse(window.localStorage.getItem('denInreResanPlaces')) or []

	getDefaultData: ->
		@data = JSON.parse(window.localStorage.getItem('denInreResanPlaces')) or [
			{
				station: undefined
			}
			{
				station: undefined
			}
			{
				station: undefined
			}
			{
				station: undefined
			}
		]

	onSetPlace: (data) ->
		
		if data.station
			data.station.Name = @cleanStationName data.station.Name
		@data[data.spot] = _.extend @data[data.spot], data
		window.localStorage.setItem 'denInreResanPlaces', JSON.stringify @data
		Tracking.trackEvent(Tracking.CATEGORIES.PLACES, Tracking.EVENTS.PLACES.ADDED)
		@trigger @data

	cleanStationName: (str) ->
		re = /(\([\s\S]*\))/
		m = undefined
		m = re.exec(str)
		if m then str.substr(0, m.index - 1) else str

