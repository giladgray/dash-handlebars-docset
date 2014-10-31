fs        = require 'fs'        # file loading
cheerio   = require 'cheerio'   # html parsing
Sequelize = require 'sequelize' # db building

NAME = 'handlebars.docset'

# HTML Guides, saved from http://handlebarsjs.com
FILES = {
  'Introduction'    : 'index.html'
  'Block Helpers'   : 'block_helpers.html'
  'Builtin Helpers' : 'builtin_helpers.html'
  'Execution'       : 'execution.html'
  'Expressions'     : 'expressions.html'
  'Precompilation'  : 'precompilation.html'
  'API Reference'   : 'reference.html'
}

# type: {name: path, ...}
docset =
  Guide: {}
  Section: {}

for title, file of FILES
  $ = cheerio.load fs.readFileSync("handlebars/#{file}")
  # register each file as a Guide
  docset.Guide[title] = "#{file}"
  # register each h2 as a Section
  $('h2').each ->
    $el   = $(@)
    title = $el.text().trim()
    docset.Section[title] = "#{file}##{$el.attr('id')}"

console.log docset

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
