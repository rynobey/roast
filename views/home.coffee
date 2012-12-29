doctype 5
html ->
  head ->
    title 'Roast::Home'
    script src:'/js/jquery-1.8.3.js'
    script src:'/partials/navbar'
    script src:'/partials/keyval'
    script src:'/partials/status'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
  body ->
    div class:'navbar', ->
    div class:'page', ->
      div class:'status', ->
      div class:'content', ->
      form action: '/users/coffees', method: 'post', ->
        div class: 'field', ->
          label for: 'params',  -> 'Qty: '
          input type: 'number', id: 'params', name: 'params', value: '1'
          input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
          input type: 'hidden', id: 'url', name: 'url', value: '/home'
          button type: 'submit', -> 'ADD COFFEE'

coffeescript ->
  $(($) ->
    $('div.navbar').prepend($(templates.navbar()))
    $('#homebutton').toggleClass('selected')
    $('div.status').prepend($(templates.status()))
    $.ajax({
      url: '/users/all'
      success: (data) ->
        $($('div')[0]).append(
          $(templates.keyval({
            key: "Logged in as "
            val: data.name
          }))
        )
        $($('div')[0]).append(
          $(templates.keyval({
            key: "Your credit balance is: R "
            val: data.balance
          }))
        )
        $($('div')[0]).append(
          $(templates.keyval({
            key: "Total number of coffees consumed: "
            val: data.coffees.length
          }))
        )
      dataType: 'json'
    })
  )
