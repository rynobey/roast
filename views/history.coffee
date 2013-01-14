div class: 'page', id:'page', ->
  br()
  p style:'margin-top:0px;padding-top:0px;', align:'center', -> "To be implemented..."
  #if @msg?
  #  div class: 'msgbox', -> @msg
  #else
  #  div class: 'msgbox', ->
  #    'View your account history:'
  #div class:'center', ->
  #  form id: 'search-form', action: '/users/coffees', ->
  #    input type: 'text', id: 'fromdate', name: 'from'
  #    input type: 'text', id: 'todate', name: 'to'
  #    button id:'formbutton', name: 'showCoffees', -> 'SHOW'

coffeescript ->
  $(($) ->
    #$('#search-form').unbind('submit')
    #$('#formbutton').unbind('click')
    #$('#formbutton').bind('click', (event) ->
    #  event.preventDefault()
    #  $('#content-div').children().replaceWith($('<div></div>'))
    #  selected = []
    #  totalCost = 0
    #  fromDate = $('#fromdate').datepicker('getDate')
    #  toDate = $('#todate').datepicker('getDate')
    #  for coffee in dlData.coffees
    #    cDate = new Date(coffee.consumedAt)
    #    cost = coffee.cost
    #    if cDate >= fromDate and cDate <= toDate
    #      temp = {
    #        columns: ["#{cDate}", "#{cost}"]
    #      }
    #      selected.push(temp)
    #      totalCost = totalCost + cost
    #  if selected.length > 0
    #    head = [{
    #      columns: [" Coffee Count: #{selected.length} ",
    #      " Total Cost: R #{totalCost} "]
    #    }]
    #    $('#content-div').append($(templates.table({
    #      rows: head.concat(selected)
    #    })))
    #  else
    #    $('#content-div').append($(templates.keyval({
    #      key: 'No '
    #      val: 'Results!'
    #    })))
    #)
    #$("#fromdate").datepicker({changeMonth: true, changeYear: true})
    #$("#fromdate").datepicker("setDate", -7)
    #$("#todate").datepicker({changeMonth: true, changeYear: true})
    #$("#todate").datepicker("setDate", +1)
    #$($('#content-div')).append($(templates.table()))
  )
