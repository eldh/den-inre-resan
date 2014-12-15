React = require 'react/addons'
Router = require 'react-router'
NoBounce = require '../modules/nobounce'
Reflux = require 'reflux'
PlaceStore = require '../stores/place--store'
TravelActions = require '../actions/travel--actions'
TouchSupportMixin = require '../mixins/touch-support'
VelocityTransition = React.createFactory require '../viewcomponents/transition/velocity-transition'
RouteHandler = React.createFactory Router.RouteHandler

module.exports = React.createClass 

	displayName: 'AppView'

	mixins: [Reflux.ListenerMixin, TouchSupportMixin, Router.State]

	componentDidMount: ->
		@listenTo PlaceStore, @onPlaceDataChange, @onPlaceDataChange

	onPlaceDataChange: (data) ->
		@setState 
			places: data

	getInitialState: -> {}

	render: ->
		RouteHandler
			params: @getParams()
			routes: @getRoutes()
			query: @getQuery()
			places: @state.places
			key: @getParams().spot + @getRoutes()[1]?.name