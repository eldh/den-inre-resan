Velocity = require 'velocity-animate'
Style = require '../utils/style-constants'
module.exports = AnimateContentMixin =
	getInitialState: ->
		justMounted: true

	componentWillUpdate: ->
		return unless content = $ @refs.animate?.getDOMNode()

		@oldHeight = content.outerHeight()
		@oldWidth = content.outerWidth()
		content.css
			height: 'auto'
			width: 'auto'

	componentDidUpdate: ->
		return unless content = $ @refs.animate?.getDOMNode()
		contentElem = content.get()

		@newHeight = content.outerHeight()
		@newWidth = content.outerWidth()
		unless @newHeight is @oldHeight and @newWidth is @oldWidth
			content.css
				height: @oldHeight
				width: @oldWidth
				overflow: 'hidden'
				# opacity: 0

			Velocity contentElem,
				height: @newHeight
				width: @newWidth
			,
				duration: Style.transitionSpeed
				easing: Style.transitionEasingSmoothBounce
				complete: ->
					Velocity contentElem,
						opacity: 1
					, 100

					content.css
						height: 'auto'
						width: 'auto'
