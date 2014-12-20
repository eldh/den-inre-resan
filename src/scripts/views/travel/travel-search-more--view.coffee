React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
TravelActions = require '../../actions/travel--actions'

module.exports = React.createClass 

	displayName: 'TravelResultView'

	propTypes:
		travelSearch: React.PropTypes.array.isRequired

	mixins: [TagInitializer]

	render: ->
		console.log @props
		@div
			className: 'travel-sections__more'
			onClick: @onClick
		,
			if @props.loading.more
				@div {className: 'loading-page__spinner'}
			else
				'Hämta fler resor'

	onClick: ->
		unless @props.loading.more
			TravelActions.searchMore()