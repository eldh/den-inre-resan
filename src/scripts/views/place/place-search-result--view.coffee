React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
Filtered = require '../../mixins/filtered'
Navigation = require('react-router').Navigation
StationSearchActions = require '../../actions/station-search--actions'
PlaceActions = require '../../actions/place--actions'

module.exports = React.createClass 

	displayName: 'StationSearchView'

	propTypes:
		stations: React.PropTypes.array
		position: React.PropTypes.number
		syncing: React.PropTypes.bool
		spot: React.PropTypes.number

	mixins: [TagInitializer, Filtered, Navigation]

	getDefualtProps: ->
		spot: 0

	getInitialState: ->
		searchState: true

	render: ->
		@div {},
			unless @props.create then @div {className: 'overlayer__back', onClick: @goBack}, 'Tillbaka'
			@div {className: 'overlayer__cancel', onClick: @onCancel}, 'Stäng'
			@h3 {className: 'overlayer__heading ', key: 'heading'}, 'Vart vill du åka?'
			@getSearchBox
				placeholder: "T ex 'Skärmarbronx'"
				onChange: @onSearchChange
				onClear: @onSearchClear
				spinner: @props.syncing
				autoFocus: true
				key: 'searchbox'
			if @props.stations
				@ul {className: 'block-list', key: 'list'},
					_.map @props.stations, (station,i) =>
						@li
							onClick: @onListItemCLicked
							key: station.Name + i
							'data-station': i
							'data-touch-feedback': true
						, station.Name

	onListItemCLicked: (e) ->
		if @props.create
			@transitionTo 'place/icon', {spot: @props.spot}, {create: @props.create}
		else
			@goBack()
		station = @props.stations[e.currentTarget.dataset.station]
		PlaceActions.setPlace
			spot: @props.spot
			station: station
		StationSearchActions.clear()

	onSearchChange: (value) ->
		StationSearchActions.searchStation value

	onSearchClear: ->
		StationSearchActions.clear()

	onCancel: ->
		PlaceActions.removePlace spot: @props.spot
		@transitionTo 'travel', spot: @props.spot
