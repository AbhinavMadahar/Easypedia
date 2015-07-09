Easypedia
=========

Instead of managing redirects, disambiguation, and other burdens, why not just
let someone else do the work for you? This is the dream of easypedia.

Easypedia is just a single function, which takes 2 inputs. It will manage the
redirects, disambiguation, parsing, and whatnot and pass a clean JSON into a
callback. Example use case:
```javascript
var easypedia = require("easypedia");

var searchTerm = "Bernie Sanders";
easypedia(searchTerm, function(result) {
	// do something with the result
});
```

To get a page in another language, add it to the optional options object:
```javascript
easypedia(searchTerm, {language:"fr"}, callback); // French
easypedia(searchTerm, {language:"de"}, callback); // German
easypedia(searchTerm, {language:"simple"}, callback); // Simple English
```
That said, some languages have low numbers of articles, and will not have an article on a specific topic. English is the largest wikipedia by far, so it may have that missing article. Thus, Easypedia automatically tries the English wikipedia if the article was not found. To prevent using the English wikipedia as a backup, please add a `!` after the language code, like `fr!` or `de!`. This scares the computer into obeying your orders very strictly.

To know what language the page is in, use `result.language`

That said, sometimes a page does not exist. To check if it exists, please
use `result.exists`.

You can even pass an array, and it will pass the result to the callback.
**Note:** the callback will be run for each wikipedia article, but the results
will not be combined together. They will be treated separately after being
openned.
```javascript
var searchTerms = ["Unidan", "Voat"];
easypedia(searchTerms, function(result) {
	// do something with each result
});
```

If you pass an `options` object when using an array of searchTerms, the options are applied to each searchTerm.

To get the links included in a page, use ```result.links```

For those wondering, this repository follows semver.
