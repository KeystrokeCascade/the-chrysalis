

	var body = document.getElementsByTagName('body')[0]
	body.className += ' scripted'
	var all = document.getElementsByTagName('*')
	var tags = []
	for (var i = 0; i < all.length; i++) {
		var tag = all[i]
		if ((tag.nodeName.toLowerCase() === 'p' && tag.className.indexOf('voice') !== -1) || tag.className.indexOf('music') !== -1 || tag.className.indexOf('song') !== -1 || (tag.nodeName.toLowerCase() === 'span' && tag.className.indexOf('voice') !== -1 && tag.parentNode.nodeName.toLowerCase() === 'p')) {
			tags.push(tag)
		}
	}
	//var tags = document.querySelectorAll('p.voice, .music, .song')
	for (var i = 0; i < tags.length; i++) {
		if (tags[i].firstChild && tags[i].firstChild.nodeType === 3) {
			var content = tags[i].firstChild.textContent.trim()
			var character = content.charAt(0)
			if (character === '“') {
				var n = document.createElement('span')
				n.className = 'hanging-start'
				n.style.position = 'absolute'
				n.textContent = character
				tags[i].firstChild.textContent = content.substring(1)
				tags[i].insertBefore(n, tags[i].firstChild)
			}
		}
	}

