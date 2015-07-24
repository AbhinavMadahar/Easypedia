wtf_wikipedia = require 'wtf_wikipedia'
purify = require './purify'
links = require './links'

module.exports = (markup) ->
    # initial parsing
    parsed = wtf_wikipedia.parse markup

    # the further parsing is only needed for actual pages
    if parsed.type isnt "page"
        return parsed

    # purify each section
    for key, content of parsed.text
        parsed.text[key] = purify.section content

    parsed.exists = parsed.text.Intro?
    parsed.links = links parsed

    parsed
