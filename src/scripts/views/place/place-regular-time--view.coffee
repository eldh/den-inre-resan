React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
Filtered = require '../../mixins/filtered'
Icon = React.createFactory require '../../icons/icon'
Button = React.createFactory require '../../viewcomponents/button'
Navigation = require('react-router').Navigation
PlaceActions = require '../../actions/place--actions'

module.exports = React.createClass 

	displayName: 'PlaceRegularTimeView'

	mixins: [TagInitializer, Navigation]

	getDefualtProps: ->
		spot: 0

	getInitialState: ->
		searchState: true

	render: ->
		selectedPlace = @props.place
		return null unless selectedPlace
		@div {}, 
			@h4 {className: 'bottom-margin--half'}, 'Jag åker oftast dit…'
			@div {className: 'btn-group'},
				Button
					modifiers: ['inverted']
					selected: selectedPlace.regularTime is 'morning'
					onClick: @setRegularTime 'morning'
				, 'Morgon'
				Button
					modifiers: ['inverted']
					selected: selectedPlace.regularTime is 'evening'
					onClick: @setRegularTime 'evening'
				, 'Kväll'

	setRegularTime: (name) ->
		=> PlaceActions.setPlace {spot: @props.place.spot, regularTime: name}

	onCancel: ->
		@transitionTo 'travel', spot: @props.params.spot