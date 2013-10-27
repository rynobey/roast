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
    balance: {
      type:Sequelize.FLOAT,
      defaultValue:0,
      allowNull:false
    },
    sid: Sequelize.STRING,
    type: {
      type:Sequelize.STRING,
      defaultValue:0
    }
  })
  return users

module.exports.coffees = (sequelize) ->
  coffees = sequelize.define('Coffee', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    consumedByID: Sequelize.INTEGER,
    cost: Sequelize.FLOAT
  })
  return coffees

module.exports.milk = (sequelize) ->
  milk = sequelize.define('Milk', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    consumedByID: Sequelize.INTEGER,
    amount: Sequelize.INTEGER,
    cost: Sequelize.FLOAT
  })
  return milk

module.exports.purchases = (sequelize) ->
  purchases = sequelize.define('Purchase', {
    id: {
      type:Sequelize.INTEGER,
      primaryKey:true,
      autoIncrement:true
    },
    purchasedByID: Sequelize.INTEGER,
    type: Sequelize.STRING,
    amount: Sequelize.STRING,
    cost: Sequelize.FLOAT,
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
    amount: Sequelize.FLOAT,
    paymentByID: Sequelize.INTEGER,
    reference: Sequelize.STRING,
    note: Sequelize.TEXT,
    confirmed: {
      type: Sequelize.BOOLEAN,
      defaultValue: false
    }
  })
  return payments

module.exports.checkDBInit = (users) ->
  email = 'roastbanker@gmail.com'
  users.find({ where: {email:email} }).success((user) ->
    if not user?
      newUser = users.build({
        name:'Banker',
        email:'roastbanker@gmail.com',
        password:'c40b331003356d4e85272ac4286fe12602dd1eb2'
        balance:0,
        type:1
      })
      newUser.save()
  )
