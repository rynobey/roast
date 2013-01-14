div class:'page', id:'page', ->
  if @msg?
    div class: 'msgbox', -> @msg
  else
    div class: 'msgbox', ->
      'Register a new account:'
  form class: 'center login-register', action: '/register', method: 'post', ->
    input class: 'default', type: 'text', id: 'name', name: 'name', value: 'name'
    input class: 'default', type: 'text', id: 'email', name: 'email', value: 'e-mail'
    input class: 'default', type: 'text', id: 'password', name: 'password', value: 'password'
    button type:'submit', -> 'Submit'

coffeescript ->
  $(($) ->
    inputBehaviour = (id) ->
      $("##{id}").focus(() ->
        if $("##{id}").attr('class') is 'default'
          el = $("##{id}")
          if id is 'email'
            el.replaceWith('<input type="email" id="email" name="email"></input>')
          else if id is 'password'
            el.replaceWith('<input type="password" id="password" name="password"></input>')
          else if id is 'name'
            el.replaceWith('<input type="text" id="name" name="name"></input>')
          $("##{id}").focus()
          $("##{id}").focusout(() ->
            if $("##{id}").attr('class') isnt 'default' and $("##{id}").attr('value') is ''
              el = $("##{id}")
              if id is 'email'
                el.replaceWith('<input class="default" type="text" id="email" value="e-mail"></input>')
              else if id is 'password'
                el.replaceWith('<input class="default" type="text" id="password" value="password"></input>')
              else if id is 'name'
                el.replaceWith('<input class="default" type="text" id="name" value="name"></input>')
            inputBehaviour(id)
          )
      )
    inputBehaviour('name')
    inputBehaviour('email')
    inputBehaviour('password')
    $('form.login-register').on('click', (e) ->
      if $(this).find('input').attr('class') is 'default'
        e.preventDefault()
    )
  )