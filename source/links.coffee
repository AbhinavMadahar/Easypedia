links = (source) ->
    Array.prototype.contains = (token) ->
        this.indexOf(token) isnt -1

    source.links = []
    for title, content of source.text
        for sentence in content
            if sentence.links?
                for link in sentence.links
                    to = link.page or link.src
                    if not source.links.contains to
                        source.links.push to

    return source.links

module.exports = links
