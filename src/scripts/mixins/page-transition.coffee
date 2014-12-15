module.exports = PageTransitionMixinMixin =

	getInitialState: ->
		layerChange: 0

	componentWillReceiveProps: (newProps) ->
		oldLayer = @props.activeRouteHandler().props.layer
		newLayer = newProps.activeRouteHandler().props.layer

		if typeof oldLayer == 'number' and typeof newLayer == 'number'
			@setState
				layerChange: oldLayer - newLayer

	getTransition: ->
		# TODO When we figure out how to make the transitions run smoothly we can re-enable this

		# switch @state.layerChange
		# 	when 0 then 'fade'
		# 	when 1 then 'fadeDownSmall'
		# 	when -1 then 'fadeUpSmall'
		# 	else 'fade'
		'fade'
