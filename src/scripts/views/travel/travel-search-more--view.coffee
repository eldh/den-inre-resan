React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
TravelActions = require '../../actions/travel--actions'

module.exports = React.createClass 

	displayName: 'TravelSearchMoreView'

	propTypes:
		loading: React.PropTypes.object.isRequired

	mixins: [TagInitializer]

	render: ->
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