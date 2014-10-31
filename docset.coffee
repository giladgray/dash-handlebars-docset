fs        = require 'fs'        # file loading
cheerio   = require 'cheerio'   # html parsing
Sequelize = require 'sequelize' # db building

NAME = 'handlebars.docset'

# HTML Guides, saved from http://handlebarsjs.com
FILES = {
  'Overview'         : 'index.html'
  'Block Helpers'    : 'block_helpers.html'
  'Built-In Helpers' : 'builtin_helpers.html'
  'Execution'        : 'execution.html'
  'Expressions'      : 'expressions.html'
  'Precompilation'   : 'precompilation.html'
  'API Reference'    : 'reference.html'
}

# type: {name: path, ...}
docset =
  Guide: {}
  Section: {}
  Function: {}

# populate the given entry type with this element
populateEntry = (file, type) -> ->
  $el   = $(@)
  title = $el.text().trim()
  docset[type][title] = "#{file}##{$el.attr('id')}"
  # insert table of contents anchor before this element
  $el.before "<a name='//apple_ref/cpp/#{type}/#{encodeURIComponent(title)}' class='dashAnchor'></a>"

for title, file of FILES
  $ = cheerio.load fs.readFileSync("html/#{file}")
  # discover docset entries
  docset.Guide[title] = "#{file}"
  $('h2').each populateEntry(file, 'Section')
  $('h3').each populateEntry(file, 'Function')
  # standardize page <title> and <h1> tags
  $('title').text(title)
  unless $('h1').length
    $('#contents').prepend "<h1>#{title}</h1>"
  # write modified HTML to docset contents
  fs.writeFileSync "handlebars.docset/Contents/Resources/Documents/#{file}", $.html()

console.log 'Docset Configuration:'
console.log docset
console.log '\n'

# create the database!
db = new Sequelize 'database', 'username', 'password',
  dialect: 'sqlite'
  storage: "#{NAME}/Contents/Resources/docSet.dsidx"

# create the SearchIndex table, per http://kapeli.com/docsets
SearchIndex = db.define 'searchIndex',
  id:
    type: Sequelize.INTEGER
    autoIncrement: true
  name: Sequelize.STRING
  type: Sequelize.STRING
  path: Sequelize.STRING
,
  freezeTableName: true
  timestamps: false

# recreate the table and populate it from docset object
db.sync(force: true)
  .complete ->
    for type, data of docset
      for name, path of data
        SearchIndex.create {name, type, path}
