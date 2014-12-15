React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
TravelActions = require '../../actions/travel--actions'

module.exports = React.createClass 

	displayName: 'TravelLoadingView'

	propTypes:
		query: React.PropTypes.object

	mixins: [TagInitializer]

	shouldComponentUpdate: (nextProps) -> 
		nextProps.query?.name isnt @props.query?.name

	render: ->
		@div {className: 'loading-page'},
			@div {className: 'loading-page__spinner'}
			@div {className: 'loading-page__info'},
			if @props.query?.name and not @props.hideString
				strings = [
					'Vad ska du göra vid ' + @cleanStationName @props.query.name + '?'
					'Solen skiner vid ' + @cleanStationName @props.query.name + '.'
					'Kärleken väntar vid ' + @cleanStationName @props.query.name + '.'
					'It begins in ' + @cleanStationName @props.query.name + '.'
					'Snart framme vid ' + @cleanStationName @props.query.name + '.'
					'Hem till ' + @cleanStationName @props.query.name + '.'
					'Alla vägar bär till ' + @cleanStationName @props.query.name + '.'
					'Vem vill inte till ' + @cleanStationName @props.query.name + '?'
					'Stockholms Brooklyn: ' + @cleanStationName @props.query.name + '.'
					'Stockholms Upper East Side: ' + @cleanStationName @props.query.name + '.'
					'Stockholms Majorna: ' + @cleanStationName @props.query.name + '.'
					'Gräset är grönare vid ' + @cleanStationName @props.query.name + '.'
					'Long road to ' + @cleanStationName @props.query.name + '.'
					'There is a house in ' + @cleanStationName @props.query.name + '.'
					'Fucking jävla kuk-' + @cleanStationName @props.query.name + '.'
				]
				_.sample strings
			else
				String.fromCharCode 160

	cleanStationName: (str) ->
		re = /(\([\s\S]*\))/
		m = undefined
		m = re.exec(str)
		if m then str.substr(0, m.index - 1) else str