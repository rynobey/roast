# External imports
fs = require('fs')
p = require('path')
cc = require('coffeecup')
$ = require('jquery')

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
      # Render templates in partial folders as functions                        
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
      # Regular templates are rendered to html                                  
      try
        str = tpl(options)
        cb(null, str)
      catch e
        cb(e)
  )

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

module.exports.skip = (users) ->
  return (req, res, next) ->
    if req? and req.cookies? and req.cookies['connect.sid']?
      sid = extractSID(req.cookies['connect.sid'])
      users.find({ where: {sid: sid} }).success((user) ->
        if user?
          res.redirect('/')
        else
          return next()
      ).error((err) ->
        return next()
      )
    else
      return next()
