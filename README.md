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

To get the links included in a page, use ```result.links```

For those wondering, this repository follows semver.