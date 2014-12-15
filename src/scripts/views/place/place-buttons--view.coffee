React = require 'react/addons'
Reflux = require 'reflux'
Navigation = require('react-router').Navigation
TravelActions = require '../../actions/travel--actions'
Icon = React.createFactory require '../../icons/icon'
Button = React.createFactory require '../../viewcomponents/button'
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'PlacesButtons'

	mixins: [Navigation]

	propTypes:
		places: React.PropTypes.array
		selected: React.PropTypes.number

	render: ->
		React.createElement 'div', {className: 'footer'},
			_.map @props.places, (place, i) =>
				Button
					onClick: @onClick
					onLongPress: @onLongPress(i)
					className: "footer__btn"
					selected: @props.selected is i
					key: '' + i + place.icon + place.spot
					dataset: 
						station: i
				, 
					if place.icon
						Icon {name: place.icon, inverted: true}
					else
						React.createElement 'div', {className: 'footer__placeholder-btn'}, i + 1

	onLongPress: (index) ->
		=> 
			if @props.places[index]?.station
				@transitionTo 'place', {spot: index}
			else
				@transitionTo 'place/search', {spot: index}, {create: true}

	onClick: (e) ->
		index = e.currentTarget.dataset.station
		if @props.places[index]?.station

			# We need to force the search if we are already on the route. But don't search if we're already searching.
			if +index is +@props.selected and not @props.searching
				@props.performSearch @props
			# Else the route mechanism will handle the search
			else	
				@transitionTo 'travel', {spot: index}
		else
			@transitionTo 'place/search', {spot: index}, {create: true}
