React = require 'react/addons'
Reflux = require 'reflux'
TravelStore = require '../../stores/travel--store'
TravelActions = require '../../actions/travel--actions'
TravelResultView = React.createFactory require './travel-result--view'
TravelStartView = React.createFactory require './travel-start--view'
TravelLoadingView = React.createFactory require './travel-loading--view'
PlaceButtonsView = React.createFactory require '../place/place-buttons--view'
Header = React.createFactory require '../header--view'
Skyline =  React.createFactory require '../../icons/skyline'
module.exports = React.createClass 

	displayName: 'TravelStateView'

	mixins: [Reflux.ListenerMixin]

	componentDidMount: ->
		@listenTo TravelStore, @onTravelDataChange, @onTravelDataChange

	componentWillMount: ->
		@performSearch()

	componentWillReceiveProps: (newProps) ->
		if newProps.places 
			if (not @props.places?) or (@getSelected(newProps) isnt @getSelected())
				@performSearch newProps

	onTravelDataChange: (data) ->
		@setState data

	getInitialState: ->
		TravelStore.getDefaultData()

	performSearch: (props) ->
		props = props or @props
		if (selected = @getSelected()) and props.places?[selected]
			# debugger
			TravelActions.searchTrip props.places[selected]?.station

	getSelected: (props) ->
		props = props or @props
		return props.params?.spot or null

	render: ->
		selected = @getSelected()
		React.createElement 'div', {className: 'app'}, 
			Header()
			React.createElement 'div', {className: 'app__main-content'}, 
				React.createElement 'div', {className: 'app__scroll-stuff'}, 
					if @state.loading.travel or @state.loading.position or not @state.travelSearch
						TravelLoadingView
							query: @state.query
					else if @state.travelSearch.length is 0
						TravelStartView
							selected: +selected
							places: @props.places
							performSearch: @performSearch
							loading: @state.loading.travel
					else
						TravelResultView
							travelSearch: @state.travelSearch
							query: @state.query
							loading: @state.loading
			Skyline()
			if @props.places
				PlaceButtonsView
					selected: +selected
					loading: @state.loading.travel
					places: @props.places
					position: @props.position
					performSearch: @performSearch

