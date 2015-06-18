var wtf_wikipedia = require("wtf_wikipedia");

// transcribed from Coffeescript via js2.coffee
var extractLinks, extractSources,
indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

// transcribed from Coffeescript via js2.coffee
extractSources = function(sentence) {
  var i, len, link, links, results;
  links = sentence.links;
  if (links === void 0 || (links == null)) {
    return [];
  } else {
    results = [];
    for (i = 0, len = links.length; i < len; i++) {
      link = links[i];
      if (indexOf.call(link, "src") >= 0) {
        results.push(link.src);
      } else {
        results.push(link.page);
      }
    }
    return results;
  }
};

// transcribed from Coffeescript via js2.coffee
extractLinks = function(result, next) {
  var i, j, len, len1, link, links, ref, ref1, section, sentence, title;
  links = [];
  ref = result.text;
  for (title in ref) {
    section = ref[title];
    for (i = 0, len = section.length; i < len; i++) {
      sentence = section[i];
      ref1 = extractSources(sentence);
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        link = ref1[j];
        links.push(link);
      }
    }
  }
  result.links = links;
  next(result);
};

var easypedia = function(pageName, next) {
	wtf_wikipedia.from_api(pageName, "en", function(page) {
		var parsed = wtf_wikipedia.parse(page);

		if (parsed.type === "disambiguation")
			easypedia(parsed.pages[0], next);
		else if (parsed.type === "redirect")
			easypedia(parsed.redirect, next);
		else {
			extractLinks(parsed, next);
		}

	});
};

module.exports = easypedia;