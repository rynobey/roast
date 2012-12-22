utils = require('../utils')

# Export the routes
module.exports = ((app) ->

  # Test route
  app.get('/', (req, res) ->
    utils.checkDBInit()
    res.render('home')
  )

  

)
