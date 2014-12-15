Actions = require '../actions/travel--actions'
Api = require '../api/travel--api'
PlaceStore = require '../stores/place--store'
Reflux = require 'reflux'
Config = require '../config/config'
_ = require 'lodash'

module.exports = Reflux.createStore

	listenables: Actions

	init: ->
		@data =
			query: {}
			travelSearch: []

	getDefaultData: ->
		@data

	onRead: (data) ->
		Api.read data


	setPosition: (callback) ->
		@data.searchingPosition = true
		@trigger @data
		navigator.geolocation.getCurrentPosition (position) =>
			callback? position, @data
			@data.searchingPosition = false
			@trigger @data

	onTest: (data) ->
		@trigger test: Math.random() * 100

	onSearchTrip: (data) ->
		return unless data?
		@data.searching = true
		data = 
			destId: data.SiteId
			name: data.Name
		@data.query = data
		@setPosition (position) => @searchTrip(position, data)

	searchTrip: (position, data) ->
		return unless position and data.destId
		data = 
			originCoordLat: position.coords.latitude
			originCoordLong: position.coords.longitude
			# originCoordLat: parseFloat(59331373)/1000000
			# originCoordLong: parseFloat(18060435)/1000000
			originCoordName: position.name or 'Nuvarande plats'
			destId: data.destId
			name: data.name
		Api.searchTrip(data, _.bind(@onSearchTripDone(data.destId), this), false)
		@trigger @data

	onSearchTripDone: (destId) ->
		(response, dat) =>
			# We don't want to update if we have started another search
			return null if @data.searching and destId isnt @data.query.destId
			@data.travelSearch.push response
			@data.searching = false
			@trigger @data

	searchFromPosition: ->
		position = @data.position
		places = PlaceStore.data
		coordsFromPosition = 
			x: position.coords.longitude
			y: position.coords.latitude
		getDistance = @getDistance
		min = _.min places, (place) ->
			return 100000000000000000 unless place.station
			coordsFromPlace = 
				x: parseFloat(place.station.X)/1000000
				y: parseFloat(place.station.Y)/1000000
				# x: parseFloat(18060434)/1000000
				# y: parseFloat(59331376)/1000000
			getDistance coordsFromPosition, coordsFromPlace

	isWeekend: ->
		now = new Date()
		now.getDay() is 0 or now.getDay() is 6

	getDistance: (p1, p2) ->
		Math.sqrt Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2)
