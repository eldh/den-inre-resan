React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
Filtered = require '../../mixins/filtered'
Icon = React.createFactory require '../../icons/icon'
Button = React.createFactory require '../../viewcomponents/button'
RegularTimeView = React.createFactory require './place-regular-time--view'
Navigation = require('react-router').Navigation

module.exports = React.createClass 

	displayName: 'PlaceSummaryView'

	mixins: [TagInitializer, Navigation]

	getDefualtProps: ->
		spot: 0

	getInitialState: ->
		searchState: true

	render: ->
		selectedPlace = @props.place
		return null unless selectedPlace
		@div {}, 
			@div {className: 'overlayer__cancel', onClick: @onCancel}, 'Stäng'
			@div {className: 'center'}, 
				@div {className: 'bottom-margin--double'},
					Icon
						name: selectedPlace.icon
						inverted: true
						className: 'icon--l'
					Button
						modifiers: ['inverted']
						onClick: => @transitionTo 'place/icon', spot: selectedPlace.spot
					, 'Ändra ikon'
			
				@div {className: 'bottom-margin'},
					@h3 {className: 'bottom-margin--half'}, "#{selectedPlace.station?.Name or ''}" 
					Button
						modifiers: ['inverted']
						onClick: => @transitionTo 'place/search', spot: selectedPlace.spot
					, 'Ändra station'

	onCancel: ->
		@transitionTo 'travel', spot: @props.place.spot