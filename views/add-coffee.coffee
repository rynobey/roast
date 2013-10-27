script src:'/partials/summary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center small', ->
    form class:'add-coffee', action: '/users/coffees', method: 'post', ->
      span class:'space', -> 'Add Coffee'
      span class:'input', ->
        label for:'params', -> 'Qty:'
        input type: 'text', id: 'params-coffee', name: 'params', value: '1', onkeypress:"return event.keyCode!=13;"
        text ' Coffee(s)'
        input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      button type: 'button', class: 'add-coffee',->
        i class:'icon-thumbs-up', ->
        text 'Submit'
  div class: 'center small', ->
    form class:'add-milk', action: '/users/milk', method: 'post', ->
      span class:'space', -> 'Add Milk'
      span class:'input', ->
        label for:'params', -> 'Qty:'
        input type: 'text', id: 'params-milk', name: 'params', value: '100', onkeypress:"return event.keyCode!=13;"
        text ' ml'
        input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      button type: 'button', class: 'add-milk',->
        i class:'icon-thumbs-up', ->
        text 'Submit'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  $(($) ->
    $('input#params-coffee').attr('autocomplete', 'off')
    $('input#params-milk').attr('autocomplete', 'off')
    $('form.add-coffee span.input').on('click', () ->
      $('input#params-coffee').focus()
    )
    $('form.add-milk span.input').on('click', () ->
      $('input#params-milk').focus()
    )
    $(document).ready(() ->
      $(this).loadUserStats()
    )
  )
