# External imports
fs = require('fs')
app = require('express')()

# Internal imports
utils = require('./utils')

# Resources (RESTful)
require('./resources/users')(app)

# App settings
app.set('views', './views')
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
