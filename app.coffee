# External imports
express = require('express')
app = require('express')()
MySqlSessionStore = require('connect-mysql-session')(express)

# Internal imports
utils = require('./utils')

# App settings
app.set('views', './views/')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.set('dbhost', 'localhost')
app.set('dbname', 'roast')
app.set('dbuser', 'roast')
app.set('dbpass', 'Theansweris2442')
app.engine('coffee', utils.coffeeEngine)
app.use(express.cookieParser())
app.use(express.session({
  secret:'randomCookieSecretPhrase',
  store: new MySqlSessionStore(app.set('dbname'), app.set('dbuser'), app.set('dbpass'), {
    host:app.set('dbhost'),
    logging: false
  })
}))
app.use(express.bodyParser())
app.seq = utils.sequelize(app)
app.users = utils.users(app.seq)
app.coffees = utils.coffees(app.seq)
app.purchases = utils.purchases(app.seq)
app.payments = utils.payments(app.seq)
app.seq.sync()
utils.checkDBInit(app.users)

# Auth/Login route
app.post('/auth', (req, res, next) ->
  email = req.param('username', null)
  pass = req.param('password', null)
  app.users.find({ where: {email: email, password: pass} }).success((user) ->
    if user?
      id = user.id
      sid = utils.extractSID(req.cookies['connect.sid'])
      user.sid = sid
      user.save(['sid']).success(() ->
        res.redirect('/')
      ).error((err) ->
        res.redirect('/')
      )
    else
      res.redirect('/')
  ).error((err) ->
    res.redirect('/')
  )
)

# All requests pass through here for authentication
app.all('*', utils.restrict(app.users), (req, res, next) ->
   next()
)

# Import routes/resources
require('./resources/users')(app)

app.get('/partials/:view', (req, res, next) ->
  params = req.params
  res.render("partials/#{params.view}.coffee")
)

# Start the app
app.listen(3000)

# Exports
module.exports = app
