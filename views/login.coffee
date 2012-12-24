script src:'partials/index'

div ->
  h1 'login'
  form action: '/auth', method: 'post', ->
    div class: 'field', ->
      label for: 'username', -> 'Username: '
      input id: 'username', name: 'username'
    div class: 'field', ->
      label for: 'password', -> 'Password: '
      input id: 'password', name: 'password'
    button type:'submit', -> 'SIGN IN'

coffeescript ->
  $(($) ->
    $('div.p').append($(templates.index()))
  )
