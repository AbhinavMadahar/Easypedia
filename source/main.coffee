wtf_wikipedia = require 'wtf_wikipedia'
langify = require 'langify'
defaultOptions = require './defaultoptions'
parse = require './parse'
config = require './config.json'

pageCache = {}

cacheHasRoom = () ->
  maxCacheSize = 100000000 # 100 megabytes

  roughSizeOfObject = (object) ->
    objectList = []
    stack = [ object ]
    bytes = 0
    while stack.length
      value = stack.pop()
      if typeof value == 'boolean'
        bytes += 4
      else if typeof value == 'string'
        bytes += value.length * 2
      else if typeof value == 'number'
        bytes += 8
      else if typeof value == 'object' and objectList.indexOf(value) == -1
        objectList.push value
        for i of value
          stack.push value[i]
    return bytes

  return roughSizeOfObject(pageCache) < maxCacheSize

easypedia = (pagename, options, next) ->
  return if arguments.length < 2 # needs at least the name and callback

  # if next is undefined, then the options variable is probably the callback
  if options? and typeof(options) is "function" and not next?
    next = options
    options = {}

  options = defaultOptions options

  if options.cache
    for key, page of pageCache
      if pagename.toLowerCase() is key.toLowerCase()
        next null, page
        return

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
        next null, parse pagename, options.language, parsed

        if options.cache and cacheHasRoom()
          pageCache[pagename] = parse pagename, options.language, parsed

module.exports = easypedia
