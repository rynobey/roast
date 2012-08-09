# Export the routes
module.exports = ((app) ->

  # Test route
  app.get('/home', (req, res) ->
    res.render('home')
  )

)
