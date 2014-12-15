Features = require '../config/features'
_ = require 'lodash'

module.exports =
	initialize: () ->
		_.each Features['enabledFeatures'], (featureFlag) ->
			$('html').addClass 'ff-' + featureFlag
	when: (feature, alternatives) ->
		if Features.isFeatureOn(feature) and alternatives.on?
			do alternatives.on
		else if alternatives.off?
			do alternatives.off
