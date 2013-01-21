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
  timeout = 0
  statusData = {}
  processResponse = (data) ->
    console.log data.currentUrl
    if data.success
      console.log data
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
    if statusData? and statusData.balance? and statusData.totSpent?
      $('span#summary').replaceWith(templates.summary({
        balance:statusData.balance,
        totSpent:statusData.totSpent,
        totCoffees:statusData.totCoffees
      }))
    else
      $('span#summary').replaceWith(templates.summary({
        balance:'-',
        totSpent:'-',
        totCoffees:'-'
      }))
    $('form.add-coffee button').bind('click', (e) ->
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

  buttonEvent = () ->
    $('form.add-coffee button').unbind('click')
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
    $.post('/users/coffees', $('form.add-coffee').serialize(), (data) ->
      loadStatus()
    )

  $(($) ->
    $('input#params').attr('autocomplete', 'off')
    loadStatus()
    $('div.center span.input').on('click', () ->
      $('div.center input#params').focus()
    )
  )
