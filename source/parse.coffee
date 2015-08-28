# this function parses AFTER wtf_wikipedia has parsed it

# sections is the page.text object
arrayifySections = (sections) ->
  for title, content of sections
    title: title
    content: content

flatenTables = (tables) ->
  return if tables? then tables[0] else []

module.exports = (parsed) ->
  categories: parsed.categories
  images: parsed.images
  sections: arrayifySections parsed.text
  infobox: parsed.infobox
  tables: flatenTables parsed.tables
