"use strict";

const wtf_wikipedia = require("wtf_wikipedia");
const langify = require("langify");

// sets the default options
const completeOptions = (options) => {
	if (options.language === undefined)
		options.language = "en";
	// 'simple' doesn't have a language code, so don't both with it
	else if (options.language.toLowerCase() !== "simple")
		options.language = langify(options.language);

	options.cache = options.cache === undefined ? false : true;

	return options;
}

class Article {
	constructor(name, wtfjson, language) {
		this.name = name;
		this.language = langify(language);
		this.categories = wtfjson.categories;
		this._text = wtfjson.text;
	}

	get links() {
		const linksInSection = (section) => {
			let links = [];
			for (let sentence of section.sentences) {
				links = links.concat(sentence.links.map((link) => link.to))
			}
			return links;
		}

		let links = [];
		for (let section of this.sections) {
			links = links.concat(linksInSection(section));
		}
		return links;
	}

	get sections() {
		const sections = [];

		const renameLink = (link) => {
			return {to: link.page, quoted: link.src || link.page};
		}

		const renameSentence = (sentence) => {
			const links = sentence.links ? sentence.links.map(renameLink): [];
			return {content: sentence.text, links: links};
		}

		for (let key in this._text) {
			let isUseful = (sentence) => {
				if (sentence.content.slice(0, 2) === "{{")
					return false;
				else if (sentence.content.trim().indexOf("|") === 0)
					return false;
				return true;
			}
			const sentences = this._text[key].map(renameSentence).filter(isUseful);
			sections.push({
				name: key,
				sentences: sentences
			})
		}

		return sections;
	}

	isRelatedTo(other) {
		const intersection = (a, b) => a.filter((e) => b.indexOf(e) !== -1);
		const meanIntroLinksLength = (this.links.length + other.links.length) / 2;
		return intersection(this.links, other.links).length > 1.5 * Math.sqrt(meanIntroLinksLength);
	}

	relationTo(other) {
		const otherToThis = other.links.filter((link) => link === this.name).length;
		const thisToOther = this.links.filter((link) => link === other.name).length;
		const otherProportional = otherToThis / other.links.length;
		const thisProportional = thisToOther / this.links.length;
		return (otherProportional + thisProportional) / 2;
	}

	eachRelated(next) {
		const alreadyDone = [];
		const uniq = (values) => values.filter((elem, i) => values.indexOf(elem) === i);
		uniq(this.links).forEach((link) => {
			module.exports(link, {language: this.language}, (err, page) => {
				if (this.isRelatedTo(page))
					next(page);
			});
		})
	}
}

module.exports = (pagename, options, next) => {
	if (!pagename) {
		next("No page name given", null);
		return;
	}

	// options is optional
	// thus, it's possible that only the page and callback were given
	// if that was the case, then only the first 2 parameters were given
	// in that case, the 2nd parameter is the callback and the 3rd is null
	if (options && !next && typeof(options) === "function") {
		next = options;
		options = {};
	}

	options = completeOptions(options);

	wtf_wikipedia.from_api(pagename, options.language, (page) => {
		const parsed = wtf_wikipedia.parse(page);
		if (parsed.type === "disambiguation") {
			const bestpage = parsed.pages[0]
			module.exports(bestpage, options, next);
		} else if (parsed.type === "redirect") {
			module.exports(parsed.redirect, options, next);
		} else if (parsed.type === "page") {
			next(null, new Article(pagename, parsed, options.language));
		}
	});
}

module.exports("United States", (err, hitler) => {
	module.exports("Economy of the United States", (error, death) => {
		console.log("Econ:", hitler.relationTo(death));
	})
	module.exports("Canada", (error, death) => {
		console.log("Canada:", hitler.relationTo(death));
	})
})
