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
sections: {...}
categories: [...]
```

### sections
The sections property is a title and an array of section objects in the form of:

```json
name: "Intro",
content: [...]
```

The `content` property is an array of section objects, which are themselves arrays of sentence objects. A sentence object takes the following form:

```json
{
  "text": "Mexico is a spanish-speaking country in North America",
  "links": [
    {"to": "Mexico", "quoted": "Mexico"},
    {"to": "hispanophone", "quoted": "spanish-speaking"}
  ]
}
```

### categories
`categories` is an array of various categories the page belongs to.

## Options
If you want to modify the behaviour of Easypedia, pass in an `options` argument in the middle as such:

```javascript
easypedia(searchTerm, options, callback);
```

If you pass an `options` object when using an array of searchTerms, the options are applied to each searchTerm.

### Cache
To make things faster, Easypedia can store your pages in memory so that it doesn't have to make a Wikipedia request each time. Also, Easypedia will avoid having the page cache exceed 100 megabytes.

To enable this, please pass in the following option to the options object
```json
cache: true
```

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
