React = require 'react/addons'
Reflux = require 'reflux'
TagInitializer = require '../../mixins/tag-initializer'
AnimateContent = require '../../mixins/animate-content'
TravelActions = require '../../actions/travel--actions'
SectionOpenView = React.createFactory require './travel-section-open--view'
SectionClosedView = React.createFactory require './travel-section-closed--view'
_ = require 'lodash'

module.exports = React.createClass 

	displayName: 'TravelSectionView'

	propTypes:
		section: React.PropTypes.object.isRequired
		setSomethingOpen: React.PropTypes.func

	mixins: [TagInitializer, AnimateContent]

	getInitialState: ->
		open: false

	componentWillReceiveProps: (newProps) ->
		@setState(@getInitialState()) unless _.isEqual newProps.section, @props.section
	render: ->
		classes = React.addons.classSet
			'travel-section__wrapper': true
			'travel-section__wrapper--open': @props.open
			'travel-section__wrapper--closed': !@props.open
		@div
			className: classes
			onClick: @props.onClick
		,
			if @props.open
				SectionOpenView 
					ref: 'animate'
					section: @props.section
					key: 'open'
			else
				SectionClosedView
					ref: 'animate'
					section: @props.section
					key: 'closed'
