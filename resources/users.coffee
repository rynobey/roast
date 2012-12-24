utils = require('../utils')

# Export the routes
module.exports = ((app) ->

  # Test route
  app.get('/', (req, res,next) ->
    res.render('home')
  )



)
