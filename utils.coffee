# External imports
async = require('async')
fs = require('fs')
coffeekup = require('coffeekup')
mysql = require('mysql')

Forbidden = (() ->
  @name = 'Forbidden'
)
Forbidden::__proto__ = Error::

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

module.exports.restrict = () ->
  return (req, res, next) ->
    if req? and req.cookies? and req.cookies['connect.sid']?
      dbcon = mysql.createConnection({
        host: 'localhost',
        user: 'root'
        password: 'roast-mysql'
      })
      dbcon.connect()
      dbcon.query("USE roast",(err) ->
        sid = extractSID(req.cookies['connect.sid'])
        dbcon.query("SELECT id FROM users WHERE sid='#{sid}'",
        (err, rows, fields) ->
          if rows? and rows.length > 0
            return next()
          else
            res.render('login')
        )
      )
    else
      res.render('login')

module.exports.checkDBInit = () ->
  dbcon = mysql.createConnection({
    host: 'localhost',
    user: 'root'
    password: 'roast-mysql'
  })
  dbcon.connect()
  async.series([
    (cb) ->
      # Create roast db if not existing
      dbcon.query('USE roast', (err, rows, fields) ->
        if err? and (err.code is 'ER_BAD_DB_ERROR')
          console.log 'db does not exist, being created now...'
          dbcon.query('CREATE DATABASE roast', (err) ->
            cb(null)
          )
        else
          cb(null)
      )
    (cb) ->
      dbcon.query('USE roast', (err) ->
        cb(null)
      )
    (cb) ->
      # Create consumption table if not existing
      dbcon.query('CREATE TABLE IF NOT EXISTS consumption (id BIGINT AUTO_INCREMENT, 
        consumedAt DATETIME, consumedByID BIGINT, PRIMARY KEY(id))', (err) ->
        cb(null)
      )
    (cb) ->
      # Create purchases table if not existing
      dbcon.query('CREATE TABLE IF NOT EXISTS purchases (id BIGINT AUTO_INCREMENT, 
        purchasedAt DATETIME, purchasedByID BIGINT, description VARCHAR(255), 
        PRIMARY KEY(id))', (err) ->
        cb(null)
      )
    (cb) ->
      # Create payments table if not existing
      dbcon.query('CREATE TABLE IF NOT EXISTS payments (id BIGINT AUTO_INCREMENT, 
        paidAt DATETIME, paidByID BIGINT, PRIMARY KEY(id))', (err) ->
        cb(null)
      )
    (cb) ->
      # Create users table if not existing
      dbcon.query('CREATE TABLE IF NOT EXISTS users (id BIGINT AUTO_INCREMENT, 
        name VARCHAR(255), password VARCHAR(255), email VARCHAR(255), 
        createdAt DATETIME, balance FLOAT, sid VARCHAR(255), PRIMARY KEY(id))',
        (err, rows, fields) ->
          cb(null)
      )
    (cb) ->
      # Create banker account if not existing
      dbcon.query("SELECT id FROM users WHERE name='Banker' AND 
        email='roastbanker@gmail.com'", (err, rows, fields) ->
        if not rows? or not rows[0]?
          console.log 'Banker does not exist yet, being created now...'
          # Insert banker account
          dbcon.query("INSERT INTO users (name, password, email, createdAt, 
          balance) VALUES ('Banker', 'koffiekrag', 'roastbanker@gmail.com',
          NOW(), 0.0)", (err, rows, fields) ->
            dbcon.end()
            cb(null)
          )
        else
          dbcon.end()
          cb(null)
      )
  ])

extractSID = (cookie) ->
  start = cookie.indexOf(':') + 1
  end = cookie.indexOf('.')
  return cookie.substring(start, end)

module.exports.extractSID = extractSID
