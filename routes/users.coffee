utils = require('../utils')
async = require('async')

# Export the routes
module.exports = ((app) ->

  app.get('/users/name', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        res.json({balance: user.name})
    )
  )

  app.get('/users/email', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        res.json({balance: user.email})
    )
  )

  app.get('/users/balance', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        res.json({balance: user.balance})
    )
  )

  app.get('/users/coffees', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        id = user.id
        app.coffees.findAll({where: {consumedByID: id}}).success((coffees) ->
          coffeeArr = {}
          if coffees?
            coffeeArr = new Array(coffees.length)
            i = 0
            for coffee in coffees
              temp = {
                consumedAt: coffee.createdAt
                consumedByID: coffee.consumedByID
              }
              coffeeArr[i] = temp
              i = i + 1
          res.json(coffeeArr)
        )
    )
  )

  app.post('/users/coffees', (req, res, next) ->
    op = req.param('operation', null)
    params = req.param('params', null)
    url = req.param('url', null)
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        if (not (params >= 0)) or (not utils.isNumber(params))
          params = 0
        if (op? and op is 'add') and params > 0
          count = 0
          async.whilst(
            () ->
              return count < params
            (cb) ->
              coffee = app.coffees.build({
                consumedByID: user.id
                cost: app.set('coffee price')
              })
              coffee.save().success(() ->
                count = count + 1
                cb()
              ).error((err) ->
                count = count + 1
                cb()
              )
            (err) ->
              user.balance = user.balance - count*app.set("coffee price")
              user.save(['balance']).success(() ->
                res.redirect(url)
              )
          )
        else
          res.redirect(url)
    )
  )

  app.get('/users/all', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        id = user.id
        app.coffees.findAll({where: {consumedByID: id}}).success((coffees) ->
          coffeeArr = {}
          if coffees?
            coffeeArr = new Array(coffees.length)
            i = 0
            for coffee in coffees
              temp = {
                consumedAt: coffee.createdAt
                consumedByID: coffee.consumedByID
                cost: coffee.cost
              }
              coffeeArr[i] = temp
              i = i + 1
          temp = {
            name: user.name,
            email: user.email,
            balance: user.balance
            coffees: coffeeArr
          }
          res.json(temp)
        )
    )
  )
)
