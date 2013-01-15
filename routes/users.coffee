utils = require('../utils')
async = require('async')

# Export the routes
module.exports = ((app) ->

  app.get('/users/summary', (req, res, next) ->
    if req.user.type is '1'
      app.purchases.findAll().success((purchases) ->
        totSpent = 0
        totCoffee = 0
        totMilk = 0
        totSugar = 0
        for p in purchases
          totSpent = totSpent + parseFloat(p.cost)
          if p.type is 'Coffee'
            totCoffee = totCoffee + parseFloat(p.amount)
          if p.type is 'Milk'
            totMilk = totMilk + parseFloat(p.amount)
          if p.type is 'Sugar'
            totSugar = totSugar + parseFloat(p.amount)
        temp = {
          success: true,
          balance: Math.round(req.user.balance*100)/100,
          totSpent: Math.round(totSpent*100)/100,
          totCoffee: Math.round(totCoffee*100)/100,
          totMilk: Math.round(totMilk*100)/100,
          totSugar: Math.round(totSugar*100)/100
        }
        res.json(temp)
      )
    else
      sid = utils.extractSID(req.cookies['connect.sid'])
      app.users.find({where: {sid: sid}}).success((user) ->
        if user?
          id = user.id
          app.coffees.findAll({where: {consumedByID: id}}).success((coffees) ->
            i = 0
            spent = 0
            if coffees?
              coffeeArr = new Array(coffees.length)
              for coffee in coffees
                spent = spent + coffee.cost
                i = i + 1
            temp = {
              success: true,
              balance: Math.round(user.balance*100)/100,
              totSpent: Math.round(spent*100)/100,
              totCoffees: i
            }
            res.json(temp)
          )
      )
  )

  app.get('/users/payments', (req, res, next) ->
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        id = user.id
        app.payments.findAll({where: {paymentByID: id}}).success((payments) ->
          paymentArr = {}
          if payments?
            paymentArr = new Array(payment.length)
            i = 0
            for payment in payments
              temp = {
                paymentAt: payment.createdAt,
                paymentByID: payment.paymentByID
              }
              paymentArr[i] = temp
              i = i + 1
          res.json(paymentArr)
        )
    )
  )

  app.post('/users/payments', (req, res, next) ->
    op = req.param('operation', null)
    params = parseFloat(req.param('params', null))
    sid = utils.extractSID(req.cookies['connect.sid'])
    app.users.find({where: {sid: sid}}).success((user) ->
      if user?
        if (not (params >= 0)) or (not utils.isNumber(params))
          params = 0
        if (op? and op is 'add') and params > 0
          payment = app.payments.build({
            paymentByID: user.id
            amount: params
          })
          payment.save().success(() ->
            user.balance = user.balance + parseFloat(params)
            user.save(['balance']).success(() ->
              res.json({success: true})
            )
          )
        else
          res.json({success: true})
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
                res.json({
                  success: true,
                })
              )
          )
        else
          res.json({
            success: true,
          })
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
