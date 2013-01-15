utils = require('../utils')

# Export the routes
module.exports = ((app) ->

  # All authed users should be redirected to home instead of login/register
  app.all('/outdex', utils.skip(app.users), (req, res, next) ->
    next()
  )

  app.all('/login', utils.skip(app.users), (req, res, next) ->
    next()
  )

  app.all('/register', utils.skip(app.users), (req, res, next) ->
    next()
  )

  app.all('/auth', utils.skip(app.users), (req, res, next) ->
    next()
  )

  app.get('/', (req, res,next) ->
    res.redirect('/index')
  )

  app.get('/outdex', (req, res,next) ->
    res.render('outdex')
  )

  app.get('/login', (req, res, next) ->
    msg = app.locals.dispMsg
    if msg? and msg isnt ''
      app.locals.dispMsg = ''
      res.render('login', {msg: msg})
    else
      res.render('login')
  )

  app.get('/register', (req, res, next) ->
    msg = app.locals.dispMsg
    if msg? and msg isnt ''
      app.locals.dispMsg = ''
      res.render('register', {msg: msg})
    else
      res.render('register')
  )

  app.post('/register', (req, res, next) ->
    n = req.param('name', null)
    e = req.param('email', null)
    h = req.param('hash', null)
    app.users.find({ where: {email:e} }).success((user) ->
      if not user?
        app.users.build({name:n, email:e, password:h, balance:0}).save()
        app.locals.dispMsg = """
          Registration Successful! Sign in using your details:
        """
        res.redirect('/outdex#url=/login')
      else
        app.locals.dispMsg = """
          Registration Failed! That e-mail address has already been registered.
        """
        res.redirect('/outdex#url=/register')
    ).error((err) ->
      app.locals.dispMsg = """
        Oops! Something went wrong... Hopefully it doesn't happen again...
      """
      res.redirect('/outdex#url=/register')
    )
  )

  # Auth/Login route
  app.post('/auth', (req, res, next) ->
    e = req.param('email', null)
    h = req.param('hash', null)
    app.users.find({ where: {email: e, password: h} }).success((user) ->
      if user?
        sid = utils.extractSID(req.cookies['connect.sid'])
        user.sid = sid
        user.save(['sid']).success(() ->
          req.user = user
          app.locals.dispMsg = ''
          res.redirect('/index#url=/home')
        ).error((err) ->
          app.locals.dispMsg = """
            Oops! Something went wrong... Hopefully it doesn't happen again...
          """
          res.redirect('/outdex#url=/login')
        )
      else
        app.locals.dispMsg = 'Incorrect e-mail or password'
        res.redirect('/outdex#url=/login')
    ).error((err) ->
      app.locals.dispMsg = """
        Oops! Something went wrong... Hopefully it doesn't happen again...
      """
      res.redirect('/outdex#url=/login')
    )
  )

  app.get('/deauth', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        user.sid = ''
        user.save(['sid']).success(() ->
          res.redirect('/outdex#url=/login')
        ).error((err) ->
          app.locals.dispMsg = """
            Oops! Something went wrong... Hopefully it doesn't happen again...
          """
          res.redirect('/')
        )
      else
        res.redirect('/')
    ).error((err) ->
      app.locals.dispMsg = """
        Oops! Something went wrong... Hopefully it doesn't happen again...
      """
      res.redirect('/')
    )
  )

  # All other requests pass through here for authentication
  app.all('*', utils.restrict(app.users), (req, res, next) ->
     next()
  )
)
