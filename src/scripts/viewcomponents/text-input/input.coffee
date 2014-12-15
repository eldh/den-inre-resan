React = require "react/addons"
_ = require 'lodash'
module.exports = React.createClass

	displayName: 'InputElement'

	propTypes:
		className: React.PropTypes.string
		id: React.PropTypes.string.isRequired
		type: React.PropTypes.string
		name: React.PropTypes.string
		required: React.PropTypes.bool
		value: React.PropTypes.string
		onValueChanged: React.PropTypes.func

	getInitialState: ->
		isEmpty: @props.value is undefined or @props.value is ''

	componentDidMount: ->
		# Handle autofill in Webkit
		inputDOMNode = @refs.input.getDOMNode()
		inputDOMNode.addEventListener 'change', autofillHandler = (e) =>
			@onChange
				target:
					value: e.target.value
			inputDOMNode.removeEventListener 'change', autofillHandler

		# Fugly hack to fix autofill issues in firefox
		# 50 is a magic number.
		setTimeout =>
			if @isMounted()
				@onChange
					target:
						value: inputDOMNode.value
		, 50

	componentWillReceiveProps: (nextProps) ->
		@setState
			isEmpty: nextProps.value is undefined or nextProps.value is ''

	render: ->
		inputFieldClasses =
			'input': true
			'input--empty': @state.isEmpty
		inputFieldClasses[@props.className] = true if @props.className

		React.createElement 'input', _.extend @props,
			className: React.addons.classSet inputFieldClasses
			ref: 'input'
			onChange: @onChange
			size: Math.floor @props.value?.length *1.25 # For some reason this is needed...

	focus: ->
		@refs.input.getDOMNode().focus()

	onChange: (e) ->
		@setState
			isEmpty: e.target.value is ''
		if typeof @props.onValueChanged is 'function'
			@props.onValueChanged e
