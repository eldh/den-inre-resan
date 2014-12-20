Actions = require '../actions/travel--actions'
Api = require '../api/travel--api'
PlaceStore = require '../stores/place--store'
Reflux = require 'reflux'
Config = require '../config/config'
_ = require 'lodash'
Tracking = require '../tracking/tracking'

module.exports = Reflux.createStore

	listenables: Actions

	init: ->
		@data =
			query: {}
			travelSearch: []
			loading:
				position: false
				travel: false
				more: false

	getDefaultData: ->
		@data

	onRead: (data) ->
		Api.read data


	setPosition: (callback) ->
		@data.loading.position = true
		@trigger @data
		navigator.geolocation.getCurrentPosition (position) =>
			@data.position = position
			callback? position, @data
			@data.loading.position = false
			@trigger @data

	onTest: (data) ->
		@trigger test: Math.random() * 100

	onSearchTrip: (data) ->
		return unless data?
		@data.loading.travel = true
		data = 
			destId: data.SiteId
			name: data.Name
			time: data.time or @getTime()
		@data.query = data
		callback = @onSearchTripDone(data.destId)
		@setPosition (position) => @searchTrip(position, data, callback)

	onSearchMore: ->
		tripArr = @data.travelSearch[@data.travelSearch.length - 1].TripList.Trip
		time = tripArr[tripArr.length - 1].LegList.Leg[0].Origin.time
		callback = @onSearchMoreDone(@data.destId)
		console.log time, @data.position
		data = _.extend @data.query, {time: time}
		@data.loading.more = true
		@searchTrip @data.position, data, callback


	searchTrip: (position, data, callback) ->
		return unless position and data.destId
		data = 
			originCoordLat: position.coords.latitude
			originCoordLong: position.coords.longitude
			# originCoordLat: parseFloat(59331373)/1000000
			# originCoordLong: parseFloat(18060435)/1000000
			originCoordName: position.name or 'Nuvarande plats'
			destId: data.destId
			name: data.name
			time: data.time
		Tracking.trackEvent(Tracking.CATEGORIES.TRAVEL, Tracking.EVENTS.TRAVEL.SEARCH)
		Api.searchTrip(data, callback, false)
		@trigger @data

	onSearchTripDone: (destId) ->
		(response, dat) =>
			# We don't want to update if we have started another search
			return null if @isLoading() and destId isnt @data.query.destId
			@data.travelSearch.push response
			@data.loading.travel = false
			@trigger @data

	onSearchMoreDone: (destId) ->
		(response, dat) =>
			# We don't want to update if we have started another search
			return null if @data.loading.travel and destId isnt @data.query.destId
			
			index = @data.travelSearch.length - 1
			# Remove the first element, because that will be the same as last one in last search.
			response.TripList.Trip.shift()
			updated = @data.travelSearch[index].TripList.Trip.concat(response.TripList.Trip) 
			@data.travelSearch[index].TripList.Trip = updated
			@data.loading.more = false
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

	isLoading: ->
		@data.loading.travel or @data.loading.location or @data.loading.more

	getDistance: (p1, p2) ->
		Math.sqrt Math.pow((p1.x - p2.x),2) + Math.pow((p1.y - p2.y),2)

	getTime: ->
		date = new Date()
		date.setMinutes date.getMinutes() - 4
		"#{date.getHours()}:#{date.getMinutes()}"
