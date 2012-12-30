doctype 5
html ->
  head ->
    title 'Roast::Login'
    script src:'/js/jquery-1.8.3.min.js'
    script src:'/js/jquery-ui.js'
    script src:'/js/jquery.ba-bbq.min.js'
    link rel:'stylesheet',  href:'/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
    link rel:"stylesheet", type:"text/css", href:"http://fonts.googleapis.com/css?family=Great+Vibes"
  body class: 'background', ->
    div class:'tabs navbar', id:'navbar', ->
      div class:'center', ->
        p class:'title', -> 'Login'
    div class:'page', id:'page', ->
      form class: 'login-register log', action: '/auth', method: 'post', ->
        input class: 'default', type: 'text', id: 'email', name: 'email', value: 'email'
        input class: 'default', type: 'text', id: 'password', name: 'password', value: 'password'
        button type: 'submit', -> 'Submit'
        p ->
          text 'Not registered? '
          a href: '/register', -> 'Register!'

coffeescript ->
  $(($) ->
    $(document).ready(() ->
      $('body.background').show("fade", {}, 300)
    )
    $('form.login-register').on('click', (e) ->
      if $(this).find('input').attr('class') is 'default'
        e.preventDefault()
    )
    inputBehaviour = (id) ->
      $("##{id}").focus(() ->
        if $("##{id}").attr('class') is 'default'
          el = $("##{id}")
          if id is 'email'
            el.replaceWith('<input type="email" id="email"></input>')
          else if id is 'password'
            el.replaceWith('<input type="password" id="password"></input>')
          $("##{id}").focus()
          $("##{id}").focusout(() ->
            if $("##{id}").attr('class') isnt 'default' and $("##{id}").attr('value') is ''
              el = $("##{id}")
              if id is 'email'
                el.replaceWith('<input class="default" type="text" id="email" value="email"></input>')
              else if id is 'password'
                el.replaceWith('<input class="default" type="text" id="password" value="password"></input>')
            inputBehaviour(id)
          )
      )
    inputBehaviour('email')
    inputBehaviour('password')
  )
