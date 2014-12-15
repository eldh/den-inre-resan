React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
LegView = React.createFactory require './travel-section-leg--view'
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'SectionClosedView'

	propTypes:
		section: React.PropTypes.object.isRequired

	mixins: [TagInitializer]

	render: ->
		section = _.find @props.section.LegList.Leg, (seg) ->
			seg.line?
		@div
			className: 'travel-section travel-section--closed'
			'data-touch-feedback': true
		, 
			LegView
				section: _.extend section, dur: @props.section.dur