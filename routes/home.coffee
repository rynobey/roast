utils = require('../utils')

# Export the routes
module.exports = ((app) ->

  # Test route
  app.get('/', (req, res,next) ->
    res.redirect('/home')
  )

  app.get('/home', (req, res,next) ->
    msg = app.locals.dispMsg
    if msg? and msg isnt ''
      app.locals.dispMsg = ''
      res.render('home', {msg: msg})
    else
      res.render('home')
  )


)
