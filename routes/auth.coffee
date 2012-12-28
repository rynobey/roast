utils = require('../utils')

# Export the routes
module.exports = ((app) ->

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
    name = req.param('name', null)
    email = req.param('email', null)
    pass = req.param('password', null)
    app.users.find({ where: {email:email} }).success((user) ->
      console.log user
      console.log user?
      if not user?
        newUser = app.users.build({
          name:name,
          email:email
          password:pass
          balance:0
        })
        newUser.save()
        # authenticate
        app.locals.dispMsg = 'Registration Successful! Sign in using your details.'
        res.redirect('/login')
      else
        res.render('register', {msg: 'That email is already registered!'})
    ).error((err) ->
      res.render('register', {msg: err})
    )
  )

  # Auth/Login route
  app.post('/auth', (req, res, next) ->
    email = req.param('email', null)
    pass = req.param('password', null)
    app.users.find({ where: {email: email, password: pass} }).success((user) ->
      if user?
        sid = utils.extractSID(req.cookies['connect.sid'])
        user.sid = sid
        user.save(['sid']).success(() ->
          app.locals.dispMsg = 'Welcome to Roast!'
          res.redirect('/')
        ).error((err) ->
          app.locals.dispMsg = err
          res.redirect('/login')
        )
      else
        app.locals.dispMsg = 'Incorrect e-mail or password'
        res.redirect('/login')
    ).error((err) ->
      app.locals.dispMsg = err
      res.redirect('/login')
    )
  )

  app.get('/deauth', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        user.sid = ''
        user.save(['sid']).success(() ->
          res.redirect('/login')
        ).error((err) ->
          app.locals.dispMsg = err
          res.redirect('/')
        )
      else
        res.redirect('/')
    ).error((err) ->
      app.locals.dispMsg = err
      res.redirect('/')
    )
  )
)
