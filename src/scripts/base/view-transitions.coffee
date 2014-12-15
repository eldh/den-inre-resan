Transition = (name, leave, enter) ->
	{ transition: 'transition--'+name, transitionLeave: leave, transitionEnter: enter }

defaultTransition = new Transition 'fade', true, true

betweenViews = () ->

	# Commented out until we figure out which animations we actually want to use between different levels. For now, always fade.

	# if from is -1 or to is -1
	# 	return new Transition 'fade-up', true, false
	# else if from > to
	# 	return new Transition 'fade-left', true, true
	# else if from < to
	# 	return new Transition 'fade-right', true, true
	# else
	defaultTransition

module.exports = {
	betweenViews: betweenViews
	defaultTransition: defaultTransition
}
