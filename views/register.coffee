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
    input type:'hidden', id:'hash', name:'hash', value:''
    button type:'button', id:'submitbutton', ->
      i class:'icon-thumbs-up', ->
      text 'Submit'

coffeescript ->
  $(($) ->
    $(this).inputBehaviour('name')
    $(this).inputBehaviour('email')
    $(this).inputBehaviour('password')
    $(document).ready(() ->
      $('button#submitbutton').on('click', (e) ->
        if $('form.login-register').find('input').attr('class') is 'default'
          e.preventDefault()
        else
          $('form.login-register').find('input#hash').attr('value',
            hex_sha1($('form.login-register').find('input#password').attr('value')))
          $('form.login-register').find('input#password').attr('value', '')
          $('form.login-register').submit()
      )
    )
  )
