wtf_wikipedia = require 'wtf_wikipedia'

extractLinks = (result, next) ->
    result.links = []
    for keySection, section of result.text
        for keySentence, sentence of section
            if sentence.links?
                for link in sentence.links
                    result.links.push link.page

    next result

parser = (markup) ->

    # initial parsing
    parsed = wtf_wikipedia.parse markup

    # further parsing
    if parsed.type is "page"
        purify =
            section: (section) ->
                section.filter (sentence) -> sentence.text.slice(0, 2) isnt "{{"
        console.log purify.section parsed.text.Intro

    parsed

easypedia = (pageName, options, next) ->
    # make sure the inputs are all correct
    if not next? and options? # if the 3rd argument was not passed
        next = options # clearly the second was meant to be the callback

    if not options.language?
        options.language = "en"
    canChangeLanguage = (options.language.indexOf "!") is (-1)
    language = options.language.replace "!", ""
    language = language.toLowerCase()

    if typeof pageName is "object"
        for page in pageName
            easypedia page, options, next

    else
        wtf_wikipedia.from_api pageName, language, (result) ->
            parsed = parser result

            if parsed.type is "redirect"
                easypedia parsed.redirect, options, next
            else if parsed.type is "disambiguation"
                easypedia parsed.pages[0], options, next
            else if parsed.type is "page"
                parsed.name = pageName
                parsed.exists = parsed.text.Intro?
                parsed.language = language

                if parsed.exists
                    extractLinks parsed, next

                else if language isnt "en" and canChangeLanguage
                    options.language = "en"
                    easypedia pageName, options, next

module.exports = easypedia
