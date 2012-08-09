# Export the routes
module.exports = ((app) ->

  # Test route
  app.get('/test', (req, res) ->
    res.render('index')
  )

)
