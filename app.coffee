# External imports
fs = require('fs')
express = require('express')
app = require('express')()
MySqlSessionStore = require('connect-mysql-session')(express)

# Internal imports
utils = require('./utils')

# Resources (RESTful)
require('./resources/users')(app)
app.use(express.cookieParser())
app.use(
  express.session({
    secret:'randomCookieSecretPhrase',
    store:new MySqlSessionStore('roast', 'root', 'roast-mysql', {
    })
  })
)

# App settings
app.set('views', './views/')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.engine('coffee', utils.coffeeEngine)

app.get('/partials/:view', (req, res, next) ->
  params = req.params
  res.render("partials/#{params.view}.coffee")
)

# Start the app
app.listen(3000)

# Exports
module.exports = app
