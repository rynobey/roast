fs = require('fs')

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
