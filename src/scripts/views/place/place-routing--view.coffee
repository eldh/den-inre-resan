React = require 'react/addons'
Router = require 'react-router'
TagInitializer = require '../../mixins/tag-initializer'
Navigation = Router.Navigation
RouteHandler = React.createFactory Router.RouteHandler

module.exports = React.createClass 

	displayName: 'PlaceRoutingView'

	mixins: [TagInitializer, Navigation]

	render: ->
		@div {className: 'overlayer'},
			RouteHandler
				create: !!@props.query.create
				places: @props.places
				place: @props.places?[@props.params.spot]
				spot: parseInt @props.params.spot
