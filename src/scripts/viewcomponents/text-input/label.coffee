React = require "react/addons"
module.exports = React.createClass

	displayName: 'Label'

	propTypes:
		label: React.PropTypes.string.isRequired
		htmlFor: React.PropTypes.string.isRequired

	render: ->
		React.createElement 'label',
			className: 'input-label'
			htmlFor: @props.htmlFor
		, @props.label
