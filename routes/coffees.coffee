utils = require('../utils')

# Export the routes
module.exports = ((app) ->

  app.get('/coffees', (req, res,next) ->
    msg = app.locals.dispMsg
    if msg? and msg isnt ''
      app.locals.dispMsg = ''
      res.render('coffees', {msg: msg})
    else
      res.render('coffees')
  )

)
