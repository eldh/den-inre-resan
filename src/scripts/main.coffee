require '../styles/main.scss'
React = require 'react/addons'
React.initializeTouchEvents true
SetupHandler = require './utils/ajax-setup-handler'
FeatureToggler = require './feature/feature-toggler'
ReactRouter = require './base/react-router'
TravelStore = require './stores/travel--store'
# Tracking = require 'tracking/tracking'
window.jQuery = window.$ = require 'jquery'	# expose jQuery so dependencies to window.jQuery works

require 'expose-loader?React!react'

if Function.name is undefined
	Object.defineProperty Function::, 'name',
	get: ->
		name = @toString().match(/^\s*function\s*(\S*)\s*\(/)[1]
		# For better performance only parse once, and then cache the
		# result through a new accessor for repeated access.
		Object.defineProperty this, 'name',
			value: name
		name


isCordova = document.URL.indexOf('http://') is -1 and document.URL.indexOf('https://') is -1

if window.navigator.standalone
	document.body.classList.add 'ios-web-app'
SetupHandler.initialize()
FeatureToggler.initialize()
# Tracking.initialize()
# TravelStore.init()

if isCordova
	onDeviceReady = ->
		document?.body?.classList?.add? 'ios-web-app'
		ReactRouter.initialize()
	document.addEventListener 'deviceready', onDeviceReady, false
else
	ReactRouter.initialize()
