React = require 'react/addons'
Reflux = require 'reflux'
Navigation = require('react-router').Navigation
TravelActions = require '../../actions/travel--actions'
PlaceActions = require '../../actions/place--actions'
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
		maxLength = @getMaxLength()
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
					Icon {name: place.icon, inverted: true}
			if @props.places.length < maxLength
				Button
					onClick: @onClick
					className: "footer__btn footer__btn--placeholder"
					key: 'newPlace'
					dataset: 
						station: @props.places.length 
				, 
						React.createElement 'div', {className: 'footer__placeholder-icon'}, '+'


	onLongPress: (index) ->
		=> 
			if @props.places[index]?.station
				@transitionTo 'place', {spot: index}
			else
				@createPlace index
	
	onClick: (e) ->
		index = e.currentTarget.dataset.station
		if @props.places[index]?.station

			# We need to force the search if we are already on the route. But don't search if we're already searching.
			if +index is +@props.selected and not @props.loading
				@props.performSearch @props
			# Else the route mechanism will handle the search
			else	
				@transitionTo 'travel', {spot: index}
		else
			@createPlace index

	createPlace: (index) ->
		PlaceActions.setPlace {spot: +index}
		@transitionTo 'place/search', {spot: index}, {create: true}

	getMaxLength: ->
		Math.floor window.innerWidth / (40 + 15 * 2) # Magic number, height of footer
