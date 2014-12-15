Config = require("config/config")
_ = require 'lodash'

module.exports =

	searchStation: (data, callback, mock = false) ->
		api = Config.get 'apis.platsuppslag'

		defaults =
			searchstring: data

		data = _.extend defaults, data

		@makeRequest
			url: "#{api.url}#{if mock then 'mock' else ''}"
			data: data
			success: callback

	makeRequest: (options = {}) ->
		request = $.ajax
			type: options.type or 'GET'
			url: options.url
			data: options.data
			dataType: 'json'
			withCredentials: false
			crossDomain: true
		.done options.success
