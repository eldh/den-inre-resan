module.exports =
	capitalizeFirstLetter: 	(value) ->
		return value unless typeof value is 'string' and value.length > 0
		value.charAt(0).toUpperCase() + value.slice(1)

	getSpaceString: (length) ->
		returnString = ''
		for i in [0...length]
			returnString += String.fromCharCode 160
		returnString
