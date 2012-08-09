script src:'partials/index'

div ->
  p 'hello world!'

coffeescript ->
  $(($) ->
    $('div.p').append($(templates.index()))
  )
