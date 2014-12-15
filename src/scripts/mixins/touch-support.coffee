FastClick = require 'fastclick'

module.exports =
	componentDidMount: ->
		setTimeout ->
			FastClick.attach document.body
		, 10
		document.body.addEventListener 'touchstart', @onTouchStart
		document.body.addEventListener 'touchend', @onTouchEnd
		document.body.addEventListener 'touchcancel', @onTouchEnd

	onTouchEnd: ->
		# Remove all touch feedback
		nodes = document.querySelectorAll '.touch-feedback'
		for node in nodes
			node.classList.remove 'touch-feedback'

	onTouchStart: (e) ->
		# Find some better way of preventing body scroll when we have menus open.
		# return if document.body.classList.contains 'no-scroll'
		node = e.target
		while node?
			if node.dataset?.touchFeedback
				node.classList.add 'touch-feedback'
				return
			else if node.tagName is 'BODY'
				return
			node = node.parentNode
