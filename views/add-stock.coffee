script src:'/partials/adminsummary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center medium', ->
    form class:'add-stock', action: '/purchases', method: 'post', ->
      span class:'center medium', -> 'Add Stock'
      table class:'stock', ->
        tr class:'stock-header', ->
          td -> 'Type'
          td -> 'Amount'
          td -> 'Units'
          td -> 'Cost'
        tr ->
          td ->
            select class:'stock-type', ->
              option value:'Coffee', -> 'Coffee'
              option value:'Milk', -> 'Milk'
              option value:'Sugar', -> 'Sugar'
          td ->
            input type: 'text', id:'amount', name:'amount', value:'1', onkeypress:"return event.keyCode!=13;"
          td class:'unit-value', ->
            'kg'
          td ->
            span class:'stock-cost', ->
              text 'R'
              input class:'stock-cost', type:'text', id:'cost', name:'cost', value:'0', onkeypress:"return event.keyCode!=13;"
      input type: 'hidden', id: 'type', name: 'type', value: 'Coffee'
      input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      button type: 'button',->
        i class:'icon-thumbs-up', ->
        text 'Submit'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  statusData = {}
  timeout = 0
  processResponse = (data) ->
    if data.success
      if data.redirect?
        $.bbq.pushState({url:data.redirect})
        $(window).trigger('hashChange')
      if data.reload?
        $.bbq.pushState({url:data.currentUrl})
        $(window).trigger('hashChange')

  restoreStats = () ->
    timeout = 0
    $.unblockUI({fadeOut:100})
    action()

  action = () ->
    if statusData? and statusData.balance? and statusData.totCoffee?
      $('span#summary').replaceWith(templates.adminsummary({
        balance:statusData.balance,
        totSpent:statusData.totSpent,
        totCoffee:statusData.totCoffee,
        totMilk:statusData.totMilk,
        totSugar:statusData.totSugar
      }))
    else
      $('span#summary').replaceWith(templates.adminsummary({
        balance:'-',
        totSpent:'-',
        totCoffee:'-',
        totMilk:'-',
        totSugar:'-'
      }))
    $('form.add-stock button').bind('click', (e) ->
      buttonEvent()
    )

  loadStatus = () ->
    $.ajax({
      url: '/users/summary'
      success: (data) ->
        statusData = data
        setTimeout(restoreStats, timeout)
      error: () ->
        setTimeout(restoreStats, timeout)
      dataType: 'json'
    })

  setUnits = () ->
    if $('select.stock-type').attr('value') is 'Coffee'
      $('input#type').attr('value', 'Coffee')
      $('td.unit-value').replaceWith($('<td class="unit-value">kg</td>'))
    if $('select.stock-type').attr('value') is 'Milk'
      $('input#type').attr('value', 'Milk')
      $('td.unit-value').replaceWith($('<td class="unit-value">litre</td>'))
    if $('select.stock-type').attr('value') is 'Sugar'
      $('input#type').attr('value', 'Sugar')
      $('td.unit-value').replaceWith($('<td class="unit-value">kg</td>'))

  buttonEvent = () ->
    $('form.add-stock button').unbind('click')
    timeout = 500
    $.blockUI({
      fadeIn: 100,
      message: $(templates.loader()),
      css: {
        left: '48%',
        width: '0px',
        opacity: 0.6,
        border: '0px',
        color: '#FFFFFF'
      }
    })
    $.post('/purchases', $('form.add-stock').serialize(), (data) ->
      loadStatus()
    )

  $(($) ->
    $('input#amount').attr('autocomplete', 'off')
    $('input#cost').attr('autocomplete', 'off')
    loadStatus()
    $('span.stock-cost').click(() ->
      $('input.stock-cost').focus()
    )
    setUnits()
    $('div.center span.input').on('click', () ->
      $('div.center input#params').focus()
    )
    $('select.stock-type').change(() ->
      setUnits()
    )
  )
