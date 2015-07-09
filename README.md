Easypedia
=========
Easypedia is a single function, that manages redirects, disambiguation, and parsing to pass a clean JSON into a callback. Example use case:
```javascript
var easypedia = require("easypedia");

var searchTerm = "Bernie Sanders";
easypedia(searchTerm, function(result) {
	// do something with the result
});
```
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

Also, this repository uses semver.

JSON Structure
--------------
The JSON output is a tree that looks basically like this:
```json
type: "page"
name: "Canada"
language: "en"
exists: "true"
links: [...]
text: {...}
```

`type` is always a "page" because Easypedia handles redirects and disambiguations by itself

`language` is equal to the country code of the language, such as `en` `fr` or `simple`

`exists` is a boolean that says if the page has any content or if it's just a blank page. `true` if it has content and `false` if it doesn't

`links` is a list of all the links in the text, and has duplicates

### text
`text` is by far the largest and most complex property, and contains deeply nested things. To simplify, this is the structure of my name, "Abhinav":
```json
"text": {
	"Intro": [
		{
			"text": "Abhinav is a common Indian and Nepalese male name, derived from the Sanskrit language, meaning young, novel, innovative.",
			"links": [
				{"page": "Sanskrit", "src": "undefined"}
			]
		},
		{
			"text": "The word originates from the Rigveda.",
			"links": [
				{"page": "Rigveda", "src": "undefined"}
			]
		},
	]
}
```
As you can see, the `Intro` section has its own list. Other sections will have their own lists as well, and the id for those lists will be the title of the section. The first section is always `Intro`

Inside the sections are the sentences themselves, which are objects in the following format:
```json
{
	"text": "blah blah blah",
	"links": [...]
}
```
The links are a list of link objects which each have 2 properties:
- `page` is the text that had the link. If something like `Canada` is linked, then the `page` links to the correct article
- `src` is used if `page` leads to a redirect. For example `Treaty of Paris` would be the `page` because that's what was talked, but `src` would be `Paris_Peace_Treaties, 1947` because that's what was specifically linked to.
If `src` is undefined, use `page`. If `src` is defined, then use it.

Options
-------
If you want to modify the behaviour of Easypedia, pass in an `options` argument in the middle as such:
```javascript
easypedia(searchTerm, options, callback);
```
If you pass an `options` object when using an array of searchTerms, the options are applied to each searchTerm.

### Language
By default, Easypedia uses the English wikipedia. To change this, add a language property along with the language you want.

The language property must be an ISO 639-1 language code, such as `fr` or `en`. The only exception to this rule is Simple English, which is a wikipedia written entirely in easy-to-understand English. It is represented by `simple`. **NOTE**: there codes are not case-sensitive.

```javascript
easypedia(searchTerm, {language:"fr"}, callback); // French
easypedia(searchTerm, {language:"de"}, callback); // German
easypedia(searchTerm, {language:"simple"}, callback); // Simple English
```

Sometimes, a particular language will not have an article for what you want. For example, Simple English wikipedia barely has over 100,000 pages whereas the English wikipedia has almost 5 million. Because of disparities like this, the English wikipedia is good as a backup for when a specific language does not have a certain article.

If Easypedia does not find a page in a non-english wikipedia, it will try again in the English wikipedia. That way, you get at least something. For example:
```javascript
easypedia("Christopher Rave", {language: "fr"}, callback);
```
Will result an **English** page being passed into the callback because there is no French page for Christopher Rave.

To override this behaviour, use a `!` after the code, such as `fr!` `de!` `simple!`
