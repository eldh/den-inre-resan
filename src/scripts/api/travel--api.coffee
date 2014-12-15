Config = require("config/config")
_ = require 'lodash'

module.exports =
	searchResrobot: (data, callback, mock = false) ->
		api = Config.get 'apis.resrobot'

		defaults =
			from: 'Bagarmossen'
			to: 'Centralen'
			fromId: 7400002
			toId: 7400001

		data = _.extend defaults, data

		@makeRequest
			url: "#{api.url}#{if mock then 'mock' else ''}"
			data: data
			success: callback

	searchRealtime: (data, callback, mock = false) ->
		api = Config.get 'apis.realtid'

		defaults =
			siteId: 9141

		data = _.extend defaults, data

		@makeRequest
			url: "#{api.url}#{if mock then 'mock' else ''}"
			data: data
			success: callback

	searchTrip: (data, callback, mock = false) ->
		api = Config.get 'apis.reseplanerare'

		defaults =
			originCoordLat: 59.347754
			originCoordLong: 17.883724
			originCoordName: 'Nuvarande plats'
			destId: 9601
			time: @getTime()

		data = _.extend defaults, data
		@makeRequest
			url: "#{api.url}#{if mock then 'mock' else ''}"
			data: data
			success: callback


	getTime: ->
		date = new Date()
		date.setMinutes(date.getMinutes()-4)
		"#{date.getHours()}:#{date.getMinutes()}"


	makeRequest: (options = {}) ->
		request = $.ajax
			type: options.type or 'GET'
			url: options.url
			data: options.data
			dataType: 'json'
			withCredentials: false
			crossDomain: true
		.done options.success