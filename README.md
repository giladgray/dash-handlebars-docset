# Dash Handlebars Docset

> [Handlebars](http://handlebarsjs.com) docset for the excellent Dash documentation browser.

Handlebars is my favorite JS template engine because it's dead simple, wicked fast, yet highly extensible. Also its precompilation feature are just bomb.

But there's no Dash Docset! Or, there wasn't. Because now there is.

## Installation
> Work in progress.

This docset will be available as a user-contributed Dash docset.

You can add it to Dash yourself by cloning and building via the instructions below, or by downloading a release archive from the Releases page.

## Development
Building this docset yourself is simple:

1. `npm install -g coffee-script` (if you haven't already)
2. `git clone` this repo
3. `npm install`
4. `coffee docset.coffee` to rebuild the Sqlite database

The Handlebars documentation HTML files can be found in `html/`. I saved each of the files from http://handlebarsjs.com and modified them slightly to look better in Dash by removing the DevSwag image and "Fork me on GitHub" banner.

Other Dash Docset files can be found in the `handlebars.docset` folder, such as `icon.png`, `Contents/Info.plist`, and `Contents/Resources/docSet.dsidx`.

The `docset.coffee` script reads each of the HTML files to find Section and Function headers and generates the `searchIndex` database table. It also injects table-of-contents anchors to the HTML files and writes them to `handlebars.docset/Contents/Resources/Documents`.
