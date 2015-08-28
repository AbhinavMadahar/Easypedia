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

collectLinks = (sections) ->
  links = []
  for section in sections
    for sentence in section.content
      if sentence.links?
        for link in sentence.links
          links.push link.to
  return links

module.exports = (name, language, parsed) ->
  sections = arrayifySections parsed.text

  for section in sections
    for sentence in section.content
      sentence.links = sentence.links.map renameLinks if sentence.links?

  name: name
  language: language
  categories: parsed.categories
  images: parsed.images
  sections: sections
  links: collectLinks sections
