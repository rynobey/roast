# External imports
express = require('express')
app = require('express')()
Store = require('connect-mysql-session')(express)


# Internal imports
utils = require('./utils')
schema = require('./schema')

# App settings
app.set('views', './views/')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.set('dbhost', 'localhost')
app.set('dbname', 'roast')
app.set('dbuser', 'roast')
app.set('dbpass', 'Theansweris2442')
app.set('coffee price', '3')
app.set('milk price', '0.01')
# set the rendering engine
app.engine('.coffee', utils.coffeecupEngine)
app.use(express.cookieParser())
# setup the mysql session store
app.use(express.session({
  secret:'randomCookieSecretPhrase',
  store: new Store(app.set('dbname'), app.set('dbuser'), app.set('dbpass'), {
    host:app.set('dbhost'),
    logging: false
  })
}))
app.use(express.bodyParser())
# host js/css/img locally
app.use(require('connect-assets')())
app.use(express.static(__dirname + '/public'))
app.use(app.router)

# setup and expose db tables
app.seq = schema.sequelize(app)
app.users = schema.users(app.seq)
app.coffees = schema.coffees(app.seq)
app.purchases = schema.purchases(app.seq)
app.payments = schema.payments(app.seq)
app.seq.sync().success(() ->
  schema.checkDBInit(app.users)
)

# Login and Registration routes
require('./routes/auth')(app)

# index routes
require('./routes/index')(app)

# Users resource route
require('./routes/users')(app)

# Purchases resource route
require('./routes/purchases')(app)

# Route for fetching partials
app.get('/partials/:item', (req, res, next) ->
  res.render("partials/#{req.params.item}.coffee")
)

# Start the app
app.listen(80)

# Exports
module.exports = app
