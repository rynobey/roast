
# Export the routes
module.exports = ((app) ->
  
  app.post('/purchases', (req, res, next) ->
    if req.user.type is '1'
      type = req.param('type', null)
      amount = req.param('amount', null)
      cost = req.param('cost', null)
      desc = ''
      pur = app.purchases.build({
        purchasedByID: req.user.id,
        type: type,
        amount: amount,
        cost: cost,
        description: desc
      })
      pur.save().success(() ->
        app.users.find({where: {type: '1'}}).success((admin) ->
          admin.balance = admin.balance - parseFloat(cost)
          admin.save(['balance']).success(() ->
            res.json({success:true})
          )
        )
      )
    else if req.user.type is '0'
      type = req.param('type', null)
      amount = req.param('amount', null)
      cost = req.param('cost', null)
      desc = ''
      pur = app.purchases.build({
        purchasedByID: req.user.id,
        type: type,
        amount: amount,
        cost: cost,
        description: desc
      })
      pur.save().success(() ->
        app.users.find({where: {id: req.user.id}}).success((user) ->
          user.balance = user.balance + parseFloat(cost)
          user.save(['balance']).success(() ->
            res.json({success:true})
          )
        )
      )
    else
      res.json({success:false})
  )

)
