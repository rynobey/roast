doctype 5
html ->
  head ->
    title 'Roast::Login'
    script src:'/js/jquery-1.8.3.js'
  body align: "center", ->
    div align: "center", ->
      h1 'Login'
      div ->
        if @msg?
          p @msg
    div align: "center", ->
      form action: '/auth', method: 'post', ->
        div class: 'field', ->
          label for: 'email', -> 'E-mail: '
          input type: 'email', id: 'email', name: 'email'
        div class: 'field', ->
          label for: 'password', -> 'Password: '
          input type: 'password', id: 'password', name: 'password'
        button type: 'submit', -> 'SIGN IN'
    div align: "center", ->
      p ->
        text 'Not registered? '
        a href: '/register', -> 'Register!'
