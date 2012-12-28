doctype 5
html ->
  head ->
    title 'Roast::Register'
    script src:'/js/jquery-1.8.3.js'
  body align: "center", ->
    div align: "center", ->
      h1 'Register'
      div ->
        if @msg?
          p @msg
    div align: "center", ->
      form action: '/register', method: 'post', ->
        div class: 'field', ->
          label for: 'name', -> 'Name: '
          input id: 'name', name: 'name'
        div class: 'field', ->
          label for: 'email', -> 'E-mail: '
          input type: 'email', id: 'email', name: 'email'
        div class: 'field', ->
          label for: 'password', -> 'Password: '
          input type: 'password', id: 'password', name: 'password'
        button type:'submit', -> 'REGISTER'
    div align: "center", ->
      p ->
        text 'Already registered? '
        a href:'/login', -> 'Login!'
