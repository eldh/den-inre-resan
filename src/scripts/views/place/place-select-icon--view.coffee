React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
Icon = React.createFactory require '../../icons/icon'
Navigation = require('react-router').Navigation
TravelActions = require '../../actions/travel--actions'
PlaceActions = require '../../actions/place--actions'
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'PlaceSelectIconView'

	propTypes:
		station: React.PropTypes.object
		usedIcons: React.PropTypes.array

	mixins: [TagInitializer, Navigation]

	render: ->
		return null unless @props.place and @props.place.station
		@div {className: 'station-icons'},
			if not @props.create
				[
					@div {className: 'overlayer__back', onClick: @goBack}, 'Tillbaka'
					@div {className: 'overlayer__cancel', onClick: @onCancel}, 'Stäng'
				]
			@h3 {className: 'overlayer__heading'}, "Välj en ikon för #{@props.place.station.Name or 'Kymlinge'}"
			@div {className: 'station-icons'},
				_.map @iconList, (icon) =>
					isUsed = _.contains @props.usedIcons, icon
					@div
						className: "station-icons__btn #{if isUsed then 'station-icons__btn--used' else ''}"
						'data-touch-feedback': true
						'data-icon': icon
						onClick: @onIconClicked
					, 
						Icon {name: icon, inverted: true}

	onIconClicked: (e) ->
		PlaceActions.setPlace
			spot: @props.spot
			icon: e.currentTarget.dataset.icon
		if @props.create
			@transitionTo 'travel', spot: @props.spot
		else
			@goBack()


	iconList: [
		'home'
		'flower'
		'gym'
		'city'
		'basket'
		'martini'
		'heart'
		'briefcase1'
		'coffee'
	]

	onCancel: ->
		@transitionTo 'travel', spot: @props.params?.spot or 0
