# External imports
fs = require('fs')
coffeekup = require('coffeekup')
Sequelize = require('sequelize')

extractSID = (cookie) ->
  start = cookie.indexOf(':') + 1
  end = cookie.indexOf('.')
  return cookie.substring(start, end)

## Function exports
#
module.exports.extractSID = extractSID

# Function for rendering coffeekup
module.exports.coffeeEngine = (path, options, cb) ->
  fs.readFile(path, 'utf8', (err, str) ->
    if err then return cb(err)
    tpl = coffeekup.compile(str, options.settings['view options'])
    try
      str = tpl(options)
      cb(null, str)
    catch e
      cb(e)
  )

module.exports.sequelize = (app) ->
  db = app.set('dbname')
  user = app.set('dbuser')
  pass = app.set('dbpass')
  options = {host:app.set('dbhost'), logging:false}
  return new Sequelize(db, user, pass, options)

module.exports.users = (sequelize) ->
  users = sequelize.define('User', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    name: {
      type:Sequelize.STRING,
      validate: {
        is:["[a-z]", 'i']
      }
    },
    email: {
      type:Sequelize.STRING,
      validate: {
        isEmail:true
      }
    },
    password: {
      type:Sequelize.STRING,
      validate: {
        isEmpty:false,
      }
    },
    balance: Sequelize.FLOAT,
    sid: Sequelize.STRING
  })
  return users

module.exports.coffees = (sequelize) ->
  coffees = sequelize.define('Coffee', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    consumedByID: Sequelize.INTEGER
  })
  return coffees

module.exports.purchases = (sequelize) ->
  purchases = sequelize.define('Purchase', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    purchasedByID: Sequelize.INTEGER,
    description: Sequelize.STRING
  })
  return purchases

module.exports.payments = (sequelize) ->
  payments = sequelize.define('Payment', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    paymentByID: Sequelize.INTEGER
  })
  return payments

module.exports.restrict = (users) ->
  return (req, res, next) ->
    if req? and req.cookies? and req.cookies['connect.sid']?
      sid = extractSID(req.cookies['connect.sid'])
      users.find({ where: {sid: sid} }).success((user) ->
        if user?
          return next()
        else
          res.render('login')
      ).error((err) ->
        res.render('login')
      )
    else
      res.render('login')

module.exports.checkDBInit = (users) ->
  email = 'roastbanker@gmail.com'
  users.find({ where: {email:email} }).success((user) ->
    if not user?
      newUser = users.build({
        name:'Banker',
        email:'roastbanker@gmail.com'
        password:'koffiekrag'
        balance:0
      })
      newUser.save()
  )
