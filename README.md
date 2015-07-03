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

To get the links included in a page, use ```result.links```

For those wondering, this repository follows semver.