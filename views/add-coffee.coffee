script src:'/partials/summary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center small', ->
    form class:'add-coffee', action: '/users/coffees', method: 'post', ->
      span class:'space', -> 'Add Coffee'
      span class:'input', ->
        label for:'params', -> 'Qty:'
        input type: 'text', id: 'params', name: 'params', value: '1', onkeypress:"return event.keyCode!=13;"
        input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      button type: 'button',->
        i class:'icon-thumbs-up', ->
        text 'Submit'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  $(($) ->
    $('input#params').attr('autocomplete', 'off')
    $('div.center span.input').on('click', () ->
      $('div.center input#params').focus()
    )
    $(document).ready(() ->
      $(this).loadUserStats()
    )
  )
