wtf_wikipedia = require 'wtf_wikipedia'

extractLinks = (result, next) ->
	result.links = []
	for keySection, section of result.text
		for keySentence, sentence of section
			if sentence.links?
				for link in sentence.links
					result.links.push link.page

	next result

easypedia = (pageName, next) ->
	if typeof pageName is "object"
		for page in pageName
			easypedia page, next

	else
		wtf_wikipedia.from_api pageName, (result) ->
			parsed = wtf_wikipedia.parse result
			parsed.name = pageName
			if parsed.type is "redirect"
				easypedia parsed.redirect, next
			else if parsed.type is "disambiguation"
				easypedia parsed.pages[0], next
			else
				parsed.exists = parsed.text.Intro?
				extractLinks parsed, next

module.exports = easypedia
