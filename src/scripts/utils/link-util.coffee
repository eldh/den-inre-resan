Config = require '../config/config'
_ = require 'lodash'

_queryObject = (uri) ->
	queryString = {}
	uri.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"), ($0, $1, $2, $3) ->
		queryString[$1] = $3
		return

	queryString

module.exports =
	getQueryObject: ->
		_queryObject window.location.search

	extendQueryObject: (query) ->
		_.extend @getQueryObject(), (query or {})

	getRoute: (originalRoute) ->
		if originalRoute.indexOf('/') isnt -1
			routeArr = originalRoute.split '/'
			routeArr[0] = Config.get("module-base-urls.#{routeArr[0]}") or routeArr[0]

			return routeArr.join '/'
		else
			return Config.get("module-base-urls.#{originalRoute}") or originalRoute
