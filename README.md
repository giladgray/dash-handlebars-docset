# Dash Handlebars Docset

> Handlebars docset for the excellent Dash documentation browser.

Handlebars is my favorite JS template engine because it's dead simple, wicked fast, yet highly extensible. Also its precompilation feature are just bomb.

But there's no Dash Docset! Or, there wasn't. Because now there is.

## Installation
> Work in progress.

This docset will be available as a user-contributed Dash docset.

## Development
Building this docset yourself is simple:

1. `npm install -g coffee-script` (if you haven't already)
2. `git clone` this repo
3. `npm install`
4. `coffee docset.coffee` to rebuild the Sqlite database

The Handlebars documentation HTML files can be found in `handlebars.docset/Contents/Resources/Documents`. I saved each of the files from http://handlebarsjs.com and modified them slightly to look better in Dash by removing the DevSwag image, "Fork me on GitHub" banner, and Handlebars logo on all pages except the index.

Other Dash Docset files can be found in the `handlebars.docset` folder, such as `icon.png` and `Contents/Info.plist`.

The `docset.coffee` script reads each of the HTML files to find Section headers and generates the `searchIndex` database table.
