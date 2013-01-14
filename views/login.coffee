div class:'page', id:'page', ->
  if @msg?
    div class: 'msgbox', -> @msg
  else
    div class: 'msgbox', ->
      'Sign in using your registered e-mail and password:'
  form class: 'login-register', action: '/auth', method: 'post', ->
    input class: 'default', type: 'text', id: 'email', name: 'email', value: 'e-mail'
    input class: 'default', type: 'text', id: 'password', name: 'password', value: 'password'
    button type: 'submit', id:'submit', -> 'Submit'

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
          $("##{id}").focus()
          $("##{id}").focusout(() ->
            if $("##{id}").attr('class') isnt 'default' and $("##{id}").attr('value') is ''
              el = $("##{id}")
              if id is 'email'
                el.replaceWith('<input class="default" type="text" id="email" value="e-mail"></input>')
              else if id is 'password'
                el.replaceWith('<input class="default" type="text" id="password" value="password"></input>')
            inputBehaviour(id)
          )
      )
    inputBehaviour('email')
    inputBehaviour('password')
    $('button#submit').on('click', (e) ->
      if $('form.login-register').find('input').attr('class') is 'default'
        e.preventDefault()
    )
  )
