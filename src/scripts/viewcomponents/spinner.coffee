React = require "react/addons"
SpinnerJS = require 'spin.js'
_ = require 'lodash'

module.exports = React.createClass

	displayName: 'Spinner'

	# React functions

	componentDidMount: ->
		@createSpinner()

	render: ->
		classes = {}
		classes[@props.className] = @props.className?
		classes['spinner--display'] = @props.display
		React.createElement 'div',
			className: React.addons.classSet classes

	createSpinner: ->
		target = @getDOMNode()
		height = target.offsetHeight
		spinnerColor = @props.color

		# We may have an element that is not visible so
		# we attempt to get the height in a different way
		height = parseFloat(window.getComputedStyle(target).height)  if height is 0

		# If the target is tall we can afford some padding
		height *= 0.8  if height > 32

		# Prefer an explicit height if one is defined
		height = parseInt(target.getAttribute("data-spinner-size"), 10)  if target.hasAttribute("data-spinner-size")

		# Allow targets to specify the color of the spinner element
		lines = 9
		radius = height * 0.1
		length = radius * 1.5
		width = (if radius < 7 then 2 else 3)
		new SpinnerJS(
			color: spinnerColor or "#ccc"
			lines: lines
			radius: radius
			length: length
			width: width
			zIndex: "auto"
			top: "50%"
			left: "50%"
			className: 'spinner'
		).spin(target)
