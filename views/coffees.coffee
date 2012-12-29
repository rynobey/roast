doctype 5
html ->
  head ->
    title 'Roast::Coffees'
    script src:'/js/jquery-1.8.3.js'
    script src:'/partials/navbar'
    script src:'/partials/keyval'
    script src:'/partials/table'
    script src:'/js/jquery-ui.js'
    link rel:'stylesheet', href: '/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
  body ->
    div class:'navbar', ->
    div class:'page', ->
      div class:'status', ->
      div class:'content', ->
        form id: 'search-form', action: '/users/coffees', ->
          div class: 'field', ->
            label for: 'from', -> 'Date from: '
            input type: 'text', id: 'fromdate', name: 'from'
            label for: 'to', -> 'Date to: '
            input type: 'text', id: 'todate', name: 'to'
            button name: 'showCoffees', -> 'SHOW'

coffeescript ->
  dlData = {}
  $(($) ->
    $('#search-form').unbind('submit')
    $('button').unbind('click')
    $('button').bind('click', (event) ->
      event.preventDefault()
      $('#content-div').children().replaceWith($('<div></div>'))
      selected = []
      totalCost = 0
      fromDate = $('#fromdate').datepicker('getDate')
      toDate = $('#todate').datepicker('getDate')
      for coffee in dlData.coffees
        cDate = new Date(coffee.consumedAt)
        cost = coffee.cost
        if cDate >= fromDate and cDate <= toDate
          temp = {
            columns: ["#{cDate}", "#{cost}"]
          }
          selected.push(temp)
          totalCost = totalCost + cost
      if selected.length > 0
        head = [{
          columns: [" Coffee Count: #{selected.length} ",
          " Total Cost: R #{totalCost} "]
        }]
        $('#content-div').append($(templates.table({
          rows: head.concat(selected)
        })))
      else
        $('#content-div').append($(templates.keyval({
          key: 'No '
          val: 'Results!'
        })))
    )
    $("#fromdate").datepicker({changeMonth: true, changeYear: true})
    $("#fromdate").datepicker("setDate", -7)
    $("#todate").datepicker({changeMonth: true, changeYear: true})
    $("#todate").datepicker("setDate", +1)
    $($('div')[0]).prepend($(templates.navbar()))
    $('#coffeesbutton').toggleClass('selected')
    $($('#content-div')).append($(templates.table()))
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
        dlData = data
      dataType: 'json'
    })
  )
