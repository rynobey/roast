# External imports
fs = require('fs')
coffeekup = require('coffeekup')
mysql = require('mysql')

## Function exports
# Function for rendering coffeekup
module.exports.coffeeEngine = (path, options, cb) ->
  fs.readFile(path, 'utf8', (err, str) ->
    if err then return cb(err)
    tpl = coffeekup.compile(str, options.settings['view options'])
    try
      str = tpl(options)
      cb(null, str)
    catch e
      cb(e)
  )

module.exports.checkDBInit = () ->
  dbcon = mysql.createConnection({
    host: 'localhost',
    user: 'root'
    password: 'roast-mysql'
  })
  dbcon.connect()

  # Create roast db if not exists
  dbcon.query('USE roast1', (err, rows, fields) ->
   if err.code is 'ER_BAD_DB_ERROR'
     dbcon.query('CREATE DATABASE roast1')
    dbcon.query('USE roast1')
    # Create users table if not exists
    dbcon.query('CREATE TABLE IF NOT EXISTS users (id INT(8), name VARCHAR(20), 
      password VARCHAR(32), createdAt DATETIME, balance FLOAT(8), sid VARCHAR(255))')
    # Create consumption table if not exists
    # Create purchases table if not exists
    dbcon.end()
  )
