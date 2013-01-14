utils = require('../utils')

# Export the routes
module.exports = ((app) ->


  app.get('/getdata', (req, res, next) ->
    res.json({
      success: true,
    })
  )

)
