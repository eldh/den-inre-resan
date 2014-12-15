BackboneHistory = require('backbone').history
Config = require '../config/config'
OnError = require '../utils/on-javascript-error'
BackboneModels = require '../utils/backbone-models'
UserModel = require '../user/user-model'

_initialized = false

_getDimensionId = (dimensionName) ->
	throw new Error('Argument undefined: dimensionName') unless dimensionName?
	dimensions = Config.get "custom-dimensions"
	dimensionId = dimensions[dimensionName]

	unless dimensionId?
		throw new Error('Could not find dimensionId for dimensionName: ' + dimensionName)

	dimensionId

trackPageView = (url) ->
	return unless _initialized

	window.ga('send', 'pageview', url)

trackEvent = (category, action, label) ->
	return unless _initialized and category and action

	window.ga 'send', 'event', {
		'eventCategory': category
		'eventAction': action
		'eventLabel': label
	}

_loadTracker = ->
	containerId = Config.get 'analytics-id'
	throw new Error('Undefined google analytics container id!') if containerId? is false

	# snippet that initializes google analytics
	# https://developers.google.com/analytics/devguides/collection/analyticsjs/advanced
	((i, s, o, g, r, a, m) ->
		i['GoogleAnalyticsObject'] = r
		i[r] = i[r] or ->
			(i[r].q = i[r].q or []).push arguments

		i[r].l = 1 * new Date()

		a = s.createElement(o)
		m = s.getElementsByTagName(o)[0]

		a.async = 1
		a.src = g
		m.parentNode.insertBefore a, m
	) window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga'

	window.ga('create', containerId, 'auto')
	# TODO: do this manually from the entry point
	# window.ga('send', 'pageview')

_setCustomDimension = (dimension, value) ->
	window.ga 'set', _getDimensionId(dimension), value


module.exports =
	initialize: ->
		return if Config.get 'analytics-disabled'
		_loadTracker()

		OnError _trackErrorEvent

		userModel = BackboneModels.get(UserModel)


		_initialized = true

	trackEvent: trackEvent

	trackPageView: trackPageView

	CATEGORIES:
		TRAVEL: 'travel'
		PLACES: 'places'

	EVENTS:
		TRAVEL:
			TRAVEL_SEARCH: 'Travel search'
			TRAVEL_AUTOSEARCH: 'Travel auto-search'
		PLACES:
			PLACE_ADDED: 'Place added'
			PLACE_EDITED: 'Place edited'
