# Export the routes
module.exports = ((app) ->

  app.get('/', (req, res,next) ->
    res.redirect('/index')
  )

  app.get('/index', (req, res,next) ->
    res.render('index')
  )

  app.get('/home', (req, res,next) ->
    if req.user.type is '1'
      res.render('adminhome')
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('home', {msg: msg})
      else
        res.render('home')
  )

  app.get('/history', (req, res,next) ->
    msg = app.locals.dispMsg
    if msg? and msg isnt ''
      app.locals.dispMsg = ''
      res.render('history', {msg: msg})
    else
      res.render('history')
  )
)
