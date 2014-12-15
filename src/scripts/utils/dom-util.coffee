Domutil =
	isDescendant: (parent, child) ->
		node = child.parentNode
		while node?
			if node is parent
				return true
			node = node.parentNode
		false

	randomString: ->
		text = ''
		possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
		i = 0

		while i < 8
			text += possible.charAt(Math.floor(Math.random() * possible.length))
			i++
		text

	addBodyClass: (className) ->
		body = document.getElementsByTagName('body')[0]
		body.classList.add className

	removeBodyClass: (className) ->
		body = document.getElementsByTagName('body')[0]
		body.classList.remove className

	isOnLeftHalf: (node) ->
		node.offsetLeft < window.innerWidth / 2

	isOnTopHalf: (node) ->
		node.offsetTop < window.innerHeight / 2

module.exports = Domutil
