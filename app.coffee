# External imports
fs = require('fs')
express = require('express')
app = require('express')()
mysql = require('mysql')
MySqlSessionStore = require('connect-mysql-session')(express)

# Internal imports
utils = require('./utils')


# App settings
app.set('views', './views/')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.engine('coffee', utils.coffeeEngine)
utils.checkDBInit()
app.use(express.cookieParser())
app.use(
  express.session({
    secret:'randomCookieSecretPhrase',
    store: new MySqlSessionStore('roast', 'root', 'roast-mysql', {
      host:'localhost',
      logging: false
    })
  })
)
app.use(express.bodyParser())

app.post('/auth', (req, res, next) ->
  email = req.param('username', null)
  pass = req.param('password', null)
  dbcon = mysql.createConnection({
    host: 'localhost',
    user: 'root'
    password: 'roast-mysql'
  })
  dbcon.connect()
  dbcon.query("USE roast",(err) ->
    dbcon.query("SELECT id FROM users WHERE email='#{email}' AND password='#{pass}'",
    (err, rows, fields) ->
      if rows? and rows.length > 0
        id = rows[0].id
        sid = utils.extractSID(req.cookies['connect.sid'])
        dbcon.query("UPDATE users SET sid='#{sid}' WHERE id=#{id}", (err) ->
          res.redirect('/')
        )
      else
        res.redirect('/')
    )
  )
)

app.all('*', utils.restrict(), (req, res, next) ->
   next()
)

# Resources (RESTful)
require('./resources/users')(app)

app.get('/partials/:view', (req, res, next) ->
  params = req.params
  res.render("partials/#{params.view}.coffee")
)

# Start the app
app.listen(3000)

# Exports
module.exports = app
