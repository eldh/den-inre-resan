React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
Navigation = require('react-router').Navigation
TravelActions = require '../../actions/travel--actions'
Button = React.createFactory require '../../viewcomponents/button'
Icon = React.createFactory require '../../icons/icon'

module.exports = React.createClass 

	displayName: 'TravelStartView'

	propTypes:
		query: React.PropTypes.object

	mixins: [TagInitializer, Navigation]

	render: ->
		@div {className: 'start-page'},
			@h3 {className: 'center top-margin'}, 'Vart vill du åka idag?'
			@div {className: 'start-page__places'},
				_.map @props.places, (place, i) =>
					if place.icon
						Button
							onClick: @onClick
							selected: @props.selected is i
							key: '' + i + place.icon + place.spot
							className: 'start-page__button'
							dataset: 
								station: i
						, 
							Icon {name: place.icon}
							place.station.Name


	onClick: (e) ->
		index = e.currentTarget.dataset.station
		if @props.places[index]?.station
			@transitionTo 'travel', {spot: index}
		else
			@transitionTo 'place/search', {spot: index}, {create: true}
