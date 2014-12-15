React = require "react/addons"
_ = require 'lodash'

module.exports = React.createClass

	displayName: 'Button'

	propTypes:
		className: React.PropTypes.string
		selected: React.PropTypes.bool
		disabled: React.PropTypes.bool
		modifiers: React.PropTypes.array
		dataset: React.PropTypes.object

	getDefaultProps: ->
		modifiers: []

	getInitialState: ->
		pressTime: 0

	render: ->
		btnProps = _.extend @getDatasetProps(),
			className: @getClasses()
			disabled: @props.loading or @props.disabled
			onClick: @onClick
			onTouchStart: @touchDown
			onTouchEnd: @touchUp
			'data-touch-feedback': true
		React.createElement 'div', btnProps, @props.children

	touchDown: ->
		@setState
			longPressed: false
			touchDown: true
		_.delay _.bind(@onLongPress, this), 1000

	touchUp: ->
		@setState
			touchDown: false

	onLongPress: ->
		if @state.touchDown and @isMounted()
			@setState
				touchDown: false
				longPressed: true
			@props.onLongPress?()

	getDatasetProps: ->
		obj = {}
		_.map @props.dataset, (value, key) ->
			obj["data-#{key}"] = value
		obj

	getClasses: ->
		classes =
			'btn': true
			'btn--with-spinner': @props.hasSpinner
			'btn--loading': @props.loading
			'btn--selected': @props.selected
			'btn--disabled': @props.disabled
		for modifier in @props.modifiers
			classes["btn--#{modifier}"] = true
		classes[@props.className] = @props.className?
		React.addons.classSet classes

	onClick: (e) ->
		@props.onClick?(e) unless (@props.loading or @state.longPressed)
