links = (source) ->
    include = (entry) ->
        if -1 is source.links.indexOf entry
            source.links.push entry

    source.links = []
    for title, content of source.text
        for sentence in content
            if sentence.links?
                for link in sentence.links
                    to = link.page or link.src
                    include to

    return source.links

module.exports = links
