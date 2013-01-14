# External imports
fs = require('fs')
p = require('path')
cc = require('coffeecup')

extractSID = (cookie) ->
  start = cookie.indexOf(':') + 1
  end = cookie.indexOf('.')
  return cookie.substring(start, end)


## Function exports
module.exports.extractSID = extractSID

module.exports.isNumber = (o) ->
  return ! isNaN(o-0)

module.exports.coffeecupEngine = (path, options, cb) ->
  fs.readFile(path, 'utf8', (err, str) ->
    if (err) then return cb(err)
    tpl = cc.compile(str, options.settings['view options'])
    if path.indexOf('partials') > 0
      root = 'templates'
      templateName = p.basename(path, p.extname(path))
      output = """
        (function(){ 
          this.#{root} || (this.#{root} = {});
          this.#{root}[#{JSON.stringify(templateName)}] = #{tpl};
        }).call(this);
      """
      cb(null, output)
    else
      try
        str = tpl(options)
        cb(null, str)
      catch e
        cb(e)
  )

module.exports.restrict = (users) ->
  return (req, res, next) ->
    cookies = req.cookies
    if req? and cookies? and cookies['connect.sid']?
      sid = extractSID(cookies['connect.sid'])
      users.find({ where: {sid: sid} }).success((user) ->
        if user?
          req.user = user
          return next()
        else
          res.redirect('/outdex#url=/login')
      ).error((err) ->
        res.redirect('/outdex#url=/login')
      )
    else
      res.redirect('/outdex#url=/login')

module.exports.skip = (users) ->
  return (req, res, next) ->
    cookies = req.cookies
    if req? and cookies? and cookies['connect.sid']?
      sid = extractSID(cookies['connect.sid'])
      users.find({ where: {sid: sid} }).success((user) ->
        if user?
          res.redirect('/index#url=/home')
        else
          return next()
      ).error((err) ->
        return next()
      )
    else
      return next()
