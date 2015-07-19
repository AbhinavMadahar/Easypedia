wtf_wikipedia = require 'wtf_wikipedia'

isPure = (sentence) ->
    if not sentence?.text?
        return false
    else
        if sentence.text.match(/(\[|\]|\{|\}|\||<br)/)?
            return false
        parentheses = sentence.text.replace /(\(\W*?\))/g, ""

purify =
    sentence: (sentence) ->
        parentheses = (text) ->
            text.replace /(\(\W*?\))/g, ""
        whitespace = (text) ->
            commas = text.replace /\s,/g, ","
            double = commas.replace /\s\s/g, " "

        whitespace parentheses sentence

    section: (section) ->
        section.filter(isPure).map (sentence) ->
            text: purify.sentence sentence.text
            links: sentence.links

module.exports = (markup) ->
    # initial parsing
    parsed = wtf_wikipedia.parse markup

    # the further parsing is only needed for actual pages
    if parsed.type isnt "page"
        return parsed

    for key, content of parsed.text
        parsed.text[key] = purify.section content

    parsed
