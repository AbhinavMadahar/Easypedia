###
This function sets the default options for the main easypedia function

The options variable is an object with the various options:
  language: string
    description: defines what language to use
    constraints:
      * must be a valid language according to langify, or be "simple"
      * is not case-sensitive
    examples:
      * "french"
      * "fr"
    default: "en"
  cache: boolean
    description: store the page in the RAM memory cache
    default: true
###

langify = require 'langify'

module.exports = (options) ->

  # make sure that the language option is valid
  if not options.language? # if no language is given
    options.language = "en"
  else if options.language.toLowerCase() is "simple" # Simple Wikipedia
    options.language = "simple"
  else
    options.language = langify options.language

  if not options.cache?
    options.cache = false

  return options
