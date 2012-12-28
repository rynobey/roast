Sequelize = require('sequelize')

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
    cost: Sequelize.FLOAT
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
