React = require 'react/addons'
Reflux = require 'reflux'

module.exports = React.createClass 

	displayName: 'HeaderView'

	# mixins: [Reflux.ListenerMixin]

	componentDidMount: ->

	render: ->
		React.createElement 'header', {className: 'header'},
			React.createElement 'div',{className:'header__title'}, 'Den inre resan'
