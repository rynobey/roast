# External imports
fs = require('fs')
app = require('express')()
coffeekup = require('coffeekup')

# Internal imports
utils = require('./utils')

# Resources (RESTful)
require('./resources/users')(app)

# App settings
app.set('views', './views')
app.set('view engine', 'coffee')
app.set('view options', {layout:false, format:true})
app.engine('coffee', utils.coffeeEngine)

# Start the app
app.listen(3000)

# Exports
module.exports = app
