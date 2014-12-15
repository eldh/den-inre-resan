React = require 'react/addons'
Searchbox = React.createFactory require '../viewcomponents/searchbox'
_ = require 'lodash'
module.exports =
	getInitialState: ->
		filterString: undefined

	getSearchBox: (options = {}) ->
		Searchbox
			onChange: @handleSearchChange options.onChange
			onClear: @clearFilter options.onClear
			value: @state.filterString
			placeholder: options.placeholder or 'Sök'
			spinner: options.spinner
			autoFocus: options.autoFocus
			ref: 'searchinput'
			key: options.key or 'searchinput'

	filter: (input) ->
		input = input.toLowerCase()
		filter = @state.filterString?.toLowerCase()
		hit = !filter or input.indexOf(filter) isnt -1
		if hit then @matches++
		hit

	clearFilter: (callback) ->
		=>
			@setState
				filterString: null
				matches: -1
			@refs.searchinput.getDOMNode().focus()
			callback()

	noMatches: ->
		@state.matches is 0

	handleSearchChange: (callback) ->
		(e, value) =>
			@setState
				filterString: value
			callback(value)

			_.delay =>
				@setState
					matches: @matches
				@matches = 0
