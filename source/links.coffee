module.exports = (result, next) ->
    result.links = []
    for keySection, section of result.text
        for keySentence, sentence of section
            if sentence?.links?
                for link in sentence.links
                    result.links.push link.page

    next result
