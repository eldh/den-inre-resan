React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
TravelActions = require '../../actions/travel--actions'
SectionView = React.createFactory require './travel-section--view'
SearchMoreView = React.createFactory require './travel-search-more--view'

module.exports = React.createClass 

	displayName: 'TravelResultView'

	propTypes:
		travelSearch: React.PropTypes.array.isRequired

	mixins: [TagInitializer]

	getInitialState:->
		openSection: null

	render: ->
		searchError = @props.travelSearch[@props.travelSearch.length - 1].TripList.errorCode
		if searchError?
			return @getErrorView searchError

		trip = @props.travelSearch[@props.travelSearch.length - 1].TripList.Trip
		destination = _.last(trip[0].LegList.Leg).Destination.name
		@div {className: "travel-sections #{if @state.openSection then 'travel-sections--has-open' else ''}"},
			@h3 {className: 'center top-margin'}, "Till #{destination}"
			_.map trip, (section, i) =>
				SectionView
					section: section
					open: @state.openSection is i + 1
					onClick: @setOpenSection i + 1
					key: section.LegList.Leg[0].Origin.time + i + destination
			SearchMoreView loading: @props.loading

	setOpenSection: (i) ->
		=> 
			if @state.openSection is i then i = null
			@setState
				openSection: i

	getErrorView: (error) ->
		@div {className: "travel-sections--error"},
			@h3 {className: 'center'}, 
				if error is 'H895'
					'Det är snabbast att använda apostlahästarna.'
				else
					'Något gick fel. Försök igen eller åk någon annanstans.'

