wtf_wikipedia = require 'wtf_wikipedia'
langify = require 'langify'

module.exports = (pagename, options, next) ->
  return if arguments.length < 2 # needs at least the name and callback

  if options? and typeof(options) is "function" and not next?
    next = options
    options = {}
