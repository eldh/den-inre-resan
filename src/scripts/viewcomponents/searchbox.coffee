React = require "react/addons"
Spinner = React.createFactory require './spinner'
module.exports = React.createClass

	displayName: 'Searchbox'

	propTypes:
		className: React.PropTypes.string
		disabled: React.PropTypes.bool
		placeholder: React.PropTypes.string
		onClear: React.PropTypes.func.isRequired
		spinner: React.PropTypes.bool

	render: ->
		React.createElement 'div', {className: 'searchbox left-and-right-container'},
			React.createElement 'input',
				type: 'search'
				className: 'input searchbox__input'
				placeholder: @props.placeholder
				onChange: @_onChange
				value: @props.value or ''
				autoFocus: !window.Modernizr?.touch
				size: Math.floor @props.value?.length *1.25 # For some reason this is needed...
			if @props.spinner
				Spinner
					className: 'searchbox__spinner'
					display: true
					onClick: @_onClear
			else if @props.value
				React.createElement 'span',
					className: 'searchbox__clear'
					onClick: @_onClear
				, '×'

	_onChange: (e) ->
		@props.onChange?(e, e.target.value)

	_onClear: ->
		@props.onClear()
