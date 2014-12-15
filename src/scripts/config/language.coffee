Config = require './config'
Backbone = require 'backbone'

class LanguageConfig extends Backbone.Model #This is a backbone model so that we can listen to language changes, is this the wrong solution?
	'lang-url-root': Config.get 'lang-url-root'
	'lang': Config.get 'lang'

module.exports = new LanguageConfig()
