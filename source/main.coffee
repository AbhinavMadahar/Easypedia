wtf_wikipedia = require 'wtf_wikipedia'
langify = require 'langify'
parse = require './parse.coffee'
config = require './config.json'

module.exports = easypedia = (pagename, options, next) ->
  return if arguments.length < 2 # needs at least the name and callback

  if options? and typeof(options) is "function" and not next?
    next = options
    options = {}

  if not options.language?
    options.language = "en"
  else
    options.language = langify options.language

  wtf_wikipedia.from_api pagename, options.language, (page) ->
    if page is ""
      next new Error("Could not find #{pagename}"), null
      return

    parsed = wtf_wikipedia.parse page

    switch parsed.type
      when 'disambiguation'
        bestpage = parsed.pages[0]
        easypedia bestpage, options, next
      when 'redirect'
        easypedia parsed.redirect, options, next

      when 'page'
        next null, parse parsed
