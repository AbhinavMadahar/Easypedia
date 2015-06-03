var wtf_wikipedia = require("wtf_wikipedia");

var easypedia = function(pageName, next) {
	wtf_wikipedia.from_api(pageName, "en", function(page) {
		var parsed = wtf_wikipedia.parse(page);

		if (parsed.type === "disambiguation")
			easypedia(parsed.pages[0], next);
		else if (parsed.type === "redirect")
			easypedia(parsed.redirect, next);
		else
			next(parsed);

	});
};

module.exports = easypedia;