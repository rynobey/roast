div class:'page', id:'page', ->
  form action: '/users/coffees', method: 'post', ->
    div class: 'field', ->
      label for: 'params',  -> 'Qty: '
      input type: 'number', id: 'params', name: 'params', value: '1'
      input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      input type: 'hidden', id: 'url', name: 'url', value: '/home'
      button type: 'submit', -> 'ADD COFFEE'

coffeescript ->
  $(($) ->
    #$('div.navbar').prepend($(templates.navbar()))
    #$('#homebutton').toggleClass('selected')
    #$('div.status').prepend($(templates.status()))
    #$.ajax({
    #  url: '/users/all'
    #  success: (data) ->
    #    $($('div')[0]).append(
    #      $(templates.keyval({
    #        key: "Logged in as "
    #        val: data.name
    #      }))
    #    )
    #    $($('div')[0]).append(
    #      $(templates.keyval({
    #        key: "Your credit balance is: R "
    #        val: data.balance
    #      }))
    #    )
    #    $($('div')[0]).append(
    #      $(templates.keyval({
    #        key: "Total number of coffees consumed: "
    #        val: data.coffees.length
    #      }))
    #    )
    #  dataType: 'json'
    #})
  )
