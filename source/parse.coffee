# this function parses AFTER wtf_wikipedia has parsed it

# sections is the page.text object
arrayifySections = (sections) ->
  for title, content of sections
    title: title
    content: content

# takes a sentence.links and renames the keys to be more obvious
renameLinks = (links) ->
  to: links.page
  quoted: links.src or links.page

flatenTables = (tables) ->
  return if tables? then tables[0] else []

module.exports = (parsed) ->
  sections = arrayifySections parsed.text

  for section in sections
    for sentence in section.content
      sentence.links = sentence.links.map renameLinks if sentence.links?

  categories: parsed.categories
  images: parsed.images
  sections: sections
  infobox: parsed.infobox
  tables: flatenTables parsed.tables
