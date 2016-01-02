# Easypedia
Easypedia is a single function that manages redirects, disambiguation, and parsing to pass a clean JSON into a callback. Example use case:

```javascript
var easypedia = require("easypedia");

var searchTerm = "Bernie Sanders";
easypedia(searchTerm, function(error, page) {
  if (error)
    console.log(error);
  else
    // do something with the page
});
```

## JSON Structure
The simple structure of the page is as follows:

```json
name: "Canada"
language: "en"
links: [...]
content: {...}
categories: [...]
isRelatedTo: (other) => ...
relationTo: (other) => ...
```

### sections
The sections property denotes the an array of sections, such as

```javascript
{
	name: "Intro",
	sentences: [...]
}
```
The sentences are put in an array, with an example sentence being:
```javascript
{
	content: "During the Iron Age, what is now Metropolitan France was inhabited by the Gauls, a Celtic people.",
	links: [
		{to: 'Iron Age', quoted: "Iron Age"},
		{to: 'Gaul', quoted: "Gaul"},
		{to: 'Celts', quoted: 'Celtic'}
	]
}
```

### categories
`categories` is an array of various categories the page belongs to.

### isRelatedTo and relationTo
isRelatedTo accepts another page and determines if the 2 are related.

relationTo finds how closely the 2 pages are related, with a high value being more closely related

## Options
If you want to modify the behaviour of Easypedia, pass in an `options` argument in the middle as such:

```javascript
easypedia(searchTerm, options, callback);
```

If you pass an `options` object when using an array of searchTerms, the options are applied to each searchTerm.

### Language
By default, Easypedia uses the English Wikipedia. To change this, add a language property along with the language you want. It is clever enough to know what you mean.

For example, to use the French Wikipedia you could pass in any of the following:

```javascript
var options = {language: "French"};
var options = {language: "Fr"};
var options = {language: "Francais"};
var options = {language: "Français"};

easypedia("France", options, console.log);
```

Also, the language property is **NOT** case-sensitive.
