# Export the routes
module.exports = ((app) ->

  app.get('/', (req, res,next) ->
    res.redirect('/index')
  )

  app.get('/index', (req, res,next) ->
    res.render('index')
  )

  app.get('/home', (req, res, next) ->
    res.json({
      success: true,
      redirect: '/home/add-coffee'
    })
  )

  app.get('/home/add-stock', (req, res, next) ->
    if req.user.type isnt '1'
      res.json({
        success: true,
        redirect: '/home/add-coffee'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('add-stock', {msg: msg})
      else
        res.render('add-stock')
  )

  app.get('/home/stock-payment', (req, res, next) ->
    if req.user.type is '1'
      res.json({
        success: true,
        redirect: '/home/add-stock'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('stock-payment', {msg: msg})
      else
        res.render('stock-payment')
  )

  app.get('/home/confirm-payments', (req, res, next) ->
    if req.user.type isnt '1'
      res.json({
        success: true,
        redirect: '/home/add-coffee'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('confirm-payments', {msg: msg})
      else
        res.render('confirm-payments')
  )

  app.get('/home/account-stats', (req, res, next) ->
    if req.user.type isnt '1'
      res.json({
        success: true,
        redirect: '/home/add-coffee'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('account-stats', {msg: msg})
      else
        res.render('account-stats')
  )

  app.get('/home/add-coffee', (req, res,next) ->
    if req.user.type is '1'
      res.json({
        success: true,
        redirect: '/home/add-stock'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('add-coffee', {msg: msg})
      else
        res.render('add-coffee')
  )

  app.get('/home/add-payment', (req, res, next) ->
    if req.user.type is '1'
      res.json({
        success: true,
        redirect: '/home/add-stock'
      })
    else
      msg = app.locals.dispMsg
      if msg? and msg isnt ''
        app.locals.dispMsg = ''
        res.render('add-payment', {msg: msg})
      else
        res.render('add-payment')
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
