React = require 'react/addons'
Router = require 'react-router'
NoBounce = require '../modules/nobounce'
Reflux = require 'reflux'
PlaceStore = require '../stores/place--store'
TravelActions = require '../actions/travel--actions'
TouchSupportMixin = require '../mixins/touch-support'
VelocityTransition = React.createFactory require '../viewcomponents/transition/velocity-page-transition'
TransitionGroup = require('react/lib/ReactCSSTransitionGroup');
RouteHandler = React.createFactory Router.RouteHandler
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'AppView'

	mixins: [Reflux.ListenerMixin, TouchSupportMixin, Router.State]

	componentDidMount: ->
		@listenTo PlaceStore, @onPlaceDataChange, @onPlaceDataChange

	onPlaceDataChange: (data) ->
		@setState
			places: data

	getInitialState: ->
		places: PlaceStore.getDefaultData()
		transition: 'overlayerIn'

	componentWillReceiveProps: (newProps) ->
		name = @getRoutes().reverse()[0].name

		goingToPlace = name.indexOf('place') > -1
		transitionProps = {}
		if goingToPlace 
			transitionProps =
				transition: 'slideUp'
				enter: true
				leave: true
		else
			transitionProps =
				transition: 'slideDown'
				enter: true
				leave: true
		@setState
			transitionProps: transitionProps

	render: ->
		name = @getRoutes().reverse()[0].name
		# TransitionGroup {transitionName: @state.transition},
		VelocityTransition @state.transitionProps,
			RouteHandler
				params: @getParams()
				routes: @getRoutes()
				query: @getQuery()
				places: @state.places
				key: name
