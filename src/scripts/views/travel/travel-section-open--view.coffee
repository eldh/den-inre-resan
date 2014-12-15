React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
TravelActions = require '../../actions/travel--actions'
DetailedLegView = React.createFactory require './travel-section-detailed-leg--view'

module.exports = React.createClass 

	displayName: 'SectionOpenView'

	propTypes:
		section: React.PropTypes.object.isRequired

	mixins: [TagInitializer]

	render: ->
		legList = @props.section.LegList
		@div
			className: 'travel-section travel-section--open'
			'data-touch-feedback': true
			
		,
			_.map legList, (segmentArr) ->
				segmentArr = _.filter segmentArr, (segment, i) ->
					(segment.Origin.name isnt segment.Destination.name) and not (i is 0 and segment.type is 'WALK')
				_.map segmentArr, (segment, i) ->
					DetailedLegView
						section: segment
						nextSection: segmentArr[i + 1]
						lastSection: segmentArr[i - 1]
						first: i is 0
						last: i is segmentArr.length - 1
