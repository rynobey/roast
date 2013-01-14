
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
        res.json({success:true})
      )
    else
      res.json({success:false})
  )

)
