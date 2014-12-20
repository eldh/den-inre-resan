React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
StringUtil = require '../../utils/string-util'
TravelActions = require '../../actions/travel--actions'
Icon = React.createFactory require '../../icons/icon'
Button = React.createFactory require '../../viewcomponents/button'
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'SectionDetailedLegView'

	propTypes:
		section: React.PropTypes.object.isRequired
		first: React.PropTypes.bool
		last: React.PropTypes.bool
		className: React.PropTypes.string

	getDefaultProps: ->
		details: false

	mixins: [TagInitializer]

	render: ->
		section = @props.section
		lineClass = @getLineClass section.line, section.type
		classes = React.addons.classSet
			'travel-section__leg': true
			'travel-section__leg--detailed': true
			'travel-section__leg--first': @props.first
			'travel-section__leg--last': @props.last
		@div
			className: "#{classes} #{@props.className or ''}"
		, 
			Icon
				name: @getIconName section.type.toLowerCase()
				inverted: true
				className: "travel-section__icon"
				key: 'icon'
				style: 
					backgroundColor: '#' + @lineColors[lineClass]
			@div {className: 'travel-section__text', key: 'text'},
				@div {className: 'travel-section__origin', key: 'origin'},
					# @span {className: 'travel-section__time'}, @props.lastSection?.Destination.time
					@span {className: 'travel-section__place', key: 'place'}, section.Origin.name
					@span {className: 'travel-section__time', key: 'time'}, 
						section.Origin.time
					if section.line
						@span {className: 'travel-section__line'}, "#{section.line} mot #{section.dir}"

					@div {className: 'travel-section__between', key: 'between'},
						' '
					@span {className: 'travel-section__time', key: 'desttime'}, section.Destination.time
					if @props.last
							@span {className: 'travel-section__place', key: 'destplace'}, section.Destination.name
	getLineClass: (line, type) ->
		line = parseInt(line)
		type = type.toLowerCase()
		lineClass = 'gray'
		if type is 'bus'
			lineClass = switch 
				when line <= 4 then 'bluebus'
				else 'redbus'
		else if type is 'metro'
			lineClass = switch
				when line <= 11 then 'bluemetro'
				when line <= 14 then 'redmetro'
				when line <= 19 then 'greenmetro'
				else 'gray'
		else if type is 'tram'
			lineClass = switch
				when line is 7 then 'bluetram'
				when line is 12 then 'greenlocal'
				when line is 22 then 'yellowlocal'
				when line <= 26 then 'purplelocal'
				when line <= 29 then 'bluelocal'
				else 'gray'
		else if type is 'train'
			lineClass = switch
				when line <= 38 then 'bluetrain'
				when line is 45 then 'burgundytrain'
				when line is 46 then 'yellowtrain'
				else 'blacktrain'
		else if type is 'walk'
			lineClass = 'walk'
		# lineClass = switch
		# 	when line is 7 then 'tram'
		# 	when line <= 11 then 'bluemetro'
		# 	when line is 12 then 'local'
		# 	when line <= 14 then 'redmetro'
		# 	when line <= 19 then 'greenmetro'
		# 	when line <= 29 then 'local'
		# 	when line <= 38 then 'train'
		# 	when line > 300 then 'redbus'
		# 	else 'gray'
		lineClass

	getLineLetter: (type) ->
		switch type.toLowerCase()
			when 'walk' then 'W'
			when 'train' then 'J'
			when 'metro' then 'T'
			when 'tram' then 'L'
			when 'bus' then 'B'
			else '?'

	getIconName: (type) ->
		switch type
			when 'walk' then 'walk'
			when 'train' then 'train'
			when 'metro' then 'subway'
			when 'tram' then 'tram'
			when 'bus' then 'bus'
			else 'bus'

	lineColors:
		bluemetro: '0095F9'
		redmetro: 'EA5100'
		greenmetro: '85B90D'
		yellowlocal: 'e8d800'
		purplelocal: '660066'
		orangelocal: 'ea8f00'
		bluelocal: '003366'
		greenlocal: 'B5F02B'
		bluetrain: '000080'
		blacktrain: '333333'
		yellowtrain: 'B5F02B'
		burgundytrain: 'A50021'
		bluebus: '155bf9'
		redbus: 'C21734'
		bluetram: '4FB9FF'
		tram: '0095F9'
		walk: '999999'
