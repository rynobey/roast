# External imports
express = require('express')
app = require('express')()
MySqlSessionStore = require('connect-mysql-session')(express)

# Internal imports
utils = require('./utils')
schema = require('./schema.coffee')

# App settings
app.set('views', './views/')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.set('dbhost', 'localhost')
app.set('dbname', 'roast')
app.set('dbuser', 'roast')
app.set('dbpass', 'Theansweris2442')
app.set('coffee price', '2.6')
app.engine('.coffee', utils.coffeecupEngine)
app.use(express.cookieParser())
app.use(express.session({
  secret:'randomCookieSecretPhrase',
  store: new MySqlSessionStore(app.set('dbname'), app.set('dbuser'), app.set('dbpass'), {
    host:app.set('dbhost'),
    logging: false
  })
}))
app.use(express.bodyParser())
app.use(express.static(__dirname + '/assets'))

app.seq = schema.sequelize(app)
app.users = schema.users(app.seq)
app.coffees = schema.coffees(app.seq)
app.purchases = schema.purchases(app.seq)
app.payments = schema.payments(app.seq)
app.seq.sync()
schema.checkDBInit(app.users)

# All authed users should be redirected to home instead of login/register
app.all('/login', utils.skip(app.users), (req, res, next) ->
  next()
)
app.all('/register', utils.skip(app.users), (req, res, next) ->
  next()
)
app.all('/auth', utils.skip(app.users), (req, res, next) ->
  next()
)

# Login and Registration routes
require('./routes/auth')(app)

# All other requests pass through here for authentication
app.all('*', utils.restrict(app.users), (req, res, next) ->
   next()
)

# Route for fetching partials
app.get('/partials/:item', (req, res, next) ->
  res.render("partials/#{req.params.item}.coffee")
)

# Users resource route
require('./routes/users')(app)

# Home routes
require('./routes/home')(app)

# Coffees routes
require('./routes/coffees')(app)

# Start the app
app.listen(3000)

# Exports
module.exports = app
