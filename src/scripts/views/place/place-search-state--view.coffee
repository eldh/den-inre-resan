React = require 'react/addons'
Reflux = require 'reflux'
StationSearchStore = require '../../stores/station-search--store'
StationSearchActions = require '../../actions/station-search--actions'
PlaceSearchResultView = React.createFactory require './place-search-result--view'

module.exports = React.createClass 

	displayName: 'PlaceSearchStateView'

	mixins: [Reflux.ListenerMixin]

	componentDidMount: ->
		@listenTo StationSearchStore, @onStationSearchDataChange

	onStationSearchDataChange: (data) ->
		@setState data

	render: ->
		PlaceSearchResultView
			syncing: @state?.syncing
			stations: @state?.stations
			spot: parseInt @props.spot
			place: @props.place
			create: @props.create
