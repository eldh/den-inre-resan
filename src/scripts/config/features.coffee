Config = require './config'
_ = require 'lodash'

enabledFeatures = Config.get('ff')

isFeatureOn = (feature) ->
	_.contains(enabledFeatures, feature)

module.exports =
	enabledFeatures: enabledFeatures
	isFeatureOn: isFeatureOn
