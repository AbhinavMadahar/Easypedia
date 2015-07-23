isPure = (sentence) ->
    if not sentence?.text?
        return false
    else
        if sentence.text.match(/(\[|\]|\{|\}|\||<br)/)?
            return false
        parentheses = sentence.text.replace /(\(\W*?\))/g, ""

module.exports = purify =
    sentence: (sentence) ->
        parentheses = (text) ->
            text.replace /(\(\W*?\))/g, ""
        whitespace = (text) ->
            commas = text.replace /\s,/g, ","
            double = commas.replace /\s\s/g, " "

        whitespace parentheses sentence

    section: (section) ->
        section.filter(isPure).map (sentence) ->
            text: purify.sentence sentence.text
            links: sentence.links
