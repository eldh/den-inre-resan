Config = require '../config/config'
React = require 'react/addons'
Router = require 'react-router'
Route = React.createFactory Router.Route
DefaultRoute = React.createFactory Router.DefaultRoute
App = require './app--view'
TravelView = require '../views/travel/travel-state--view'
LoadingView = require '../views/travel/travel-loading--view'
PlaceRoutingView = require '../views/place/place-routing--view'
PlaceSummaryView = require '../views/place/place-summary--view'
PlaceSearchView = require '../views/place/place-search-state--view'
PlaceIconView = require '../views/place/place-select-icon--view'

module.exports =
	initialize: ->
		Router.run @routes(), Router.HashLocation, (handler) ->
			React.render React.createElement(handler, {}), document.getElementById 'app-container'

	routes: ->
		Route
			handler: App
			path: '/'
		,
			DefaultRoute
				handler: TravelView
			Route
				path: '/'
				handler: TravelView
			Route
				handler: TravelView
				path: 'travel/:spot'
				name: 'travel'
			Route
				handler: TravelView
				path: 'travel'
			Route
				handler: PlaceRoutingView
				path: 'place/:spot'
			,
				Route
					handler: PlaceSummaryView
					name: 'place'
					path: 'summary'
				Route
					handler: PlaceSearchView
					name: 'place/search'
					path: 'search'
				Route
					handler: PlaceIconView
					name: 'place/icon'
					path: 'icon'
			Route
				handler: LoadingView
				name: 'loading'
