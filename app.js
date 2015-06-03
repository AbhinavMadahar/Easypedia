var wtf_wikipedia = require("wtf_wikipedia");

var easypedia = function(pageName, next) {
    wtf_wikipedia.from_api(pageName, "en", function(markup) {
        next(wtf_wikipedia.parse(markup));
    });
};

module.exports = easypedia;