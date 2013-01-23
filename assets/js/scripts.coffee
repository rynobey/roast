$ = jQuery
timeout = 500
statusData = {}

processResponse = (data) ->
  if data.success
    if data.redirect?
      $.bbq.pushState({url:data.redirect})
      $(window).trigger('hashChange')
    if data.reload?
      $.bbq.pushState({url:data.currentUrl})
      $(window).trigger('hashChange')

isOnAdminHome = () ->
  if $.bbq.getState('url').indexOf('/home/add-stock') is 0 or $.bbq.getState('url').indexOf('/home/confirm-payments') is 0
    return true
  else
    return false

isOnUserHome = () ->
  if $.bbq.getState('url').indexOf('/home/add-coffee') is 0 or $.bbq.getState('url').indexOf('/home/add-payment') is 0 or $.bbq.getState('url').indexOf('/home/stock-payment') is 0
    return true
  else
    return false

isOnAdminHistory = () ->
  if $.bbq.getState('url').indexOf('/history') is 0
    return true
  else
    return false

isOnUserHistory = () ->
  if $.bbq.getState('url').indexOf('/history') is 0
    return true
  else
    return false

appendAdminHomeSidebarButtons = () ->
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='stock' href='/home/add-stock'><i class='icon-cart'></i></button>")
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='payments' href='/home/confirm-payments'><i class='icon-dollar'></button>")

appendUserHomeSidebarButtons = () ->
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='coffee' href='/home/add-coffee'><i class='icon-coffee'></i></button>")
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='stock' href='/home/stock-payment'><i class='icon-cart'></i></button>")
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='payment' href='/home/add-payment'><i class='icon-dollar'></i></button>")

sidebarButtons = () ->
  $('div#sidebar-left').find('button').remove()
  url = $.bbq.getState('url')
  if url?
    if isOnAdminHome()
      appendAdminHomeSidebarButtons()
      if url.indexOf('/home/add-stock') is 0
        $("button#stock").addClass('selected')
      else if url.indexOf('/home/confirm-payments') is 0
        $("button#payments").addClass('selected')
    else if isOnUserHome()
      appendUserHomeSidebarButtons()
      if url.indexOf('/home/add-coffee') is 0
        $("button#coffee").addClass('selected')
      else if url.indexOf('/home/stock-payment') is 0
        $("button#stock").addClass('selected')
      else if url.indexOf('/home/add-payment') is 0
        $("button#payment").addClass('selected')
    else if isOnAdminHistory()
      $('div#sidebar-left').find('button').remove()
    else if isOnUserHistory()
      $('div#sidebar-left').find('button').remove()
    $('div#sidebar-left').find('button').bind('click', (e) ->
      return navButtonEvent(this, e)
    )

$.fn.sidebarButtons = sidebarButtons

navButtonEvent = (el, event) ->
  event.preventDefault()
  $(el).siblings('button').removeClass('selected')
  $(el).bind('mouseleave', ->
    $(el).addClass('selected')
    $(el).unbind('mouseleave')
  )
  href = $(el).attr('href')
  $.bbq.pushState({url:href})
  $(window).trigger('hashChange')
  return false

$.fn.navButtonEvent = navButtonEvent

unblockUI = () ->
  timeout = 500
  $.unblockUI({fadeOut:100})

userStatsAction = () ->
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
  $('form button').bind('click', (e) ->
    userButtonEvent()
  )

adminStatsAction = () ->
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

loadUserStats = () ->
  $.ajax({
    url: '/users/summary'
    success: (data) ->
      statusData = data
      userStatsAction()
      #setTimeout(unblockUI, timeout)
    error: () ->
      userStatsAction()
      #setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadUserStats = loadUserStats

loadAdminStats = () ->
  $.ajax({
    url: '/users/summary'
    success: (data) ->
      statusData = data
      adminStatsAction()
      #setTimeout(unblockUI, timeout)
    error: () ->
      adminStatsAction()
      #setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadAdminStats = loadAdminStats

userButtonEvent = () ->
  $('form button').unbind('click')
  timeout = 500
  $.blockUI({
    timeout: 0,
    fadeIn: 0,
    message: $(templates.loader()),
    css: {
      left: '48%',
      width: '0px',
      opacity: 0.6,
      border: '0px',
      color: '#FFFFFF'
    }
  })
  url = $.bbq.getState('url')
  if url.indexOf('/home/add-coffee') is 0
    $.post('/users/coffees', $('form.add-coffee').serialize(), (data) ->
      loadUserStats()
    )
  else if url.indexOf('/home/add-payment') is 0
    $.post('/users/payments', $('form.add-coffee').serialize(), (data) ->
      loadUserStats()
    )
  else if url.indexOf('/home/stock-payment') is 0
    $.post('/purchases', $('form.add-stock').serialize(), (data) ->
      loadUserStats()
    )

adminButtonEvent = () ->
  $('form.add-stock button').unbind('click')
  timeout = 500
  $.blockUI({
    timeout: 0,
    fadeIn: 0,
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
    loadAdminStats()
  )

$.fn.setUnits = () ->
  if $('select.stock-type').attr('value') is 'Coffee'
    $('input#type').attr('value', 'Coffee')
    $('td.unit-value').replaceWith($('<td class="unit-value">kg</td>'))
  if $('select.stock-type').attr('value') is 'Milk'
    $('input#type').attr('value', 'Milk')
    $('td.unit-value').replaceWith($('<td class="unit-value">litre</td>'))
  if $('select.stock-type').attr('value') is 'Sugar'
    $('input#type').attr('value', 'Sugar')
    $('td.unit-value').replaceWith($('<td class="unit-value">kg</td>'))

$.fn.outerChange = (fromButton) ->
  url = $.bbq.getState('url')
  if not url? or not url or (url isnt '/login' and url isnt '/register')
    $.bbq.pushState({url:'/login'})
    url = '/login'
  if fromButton? and not fromButton
    $("button[href='#{url}']").addClass('selected')
  $('#page').loadPage(url)
      
$.fn.innerChange = (fromButton) ->
  url = $.bbq.getState('url')
  if not url? or url is '/' or url is '/home' or not url or (url is '/login' or url is '/register')
    $.bbq.pushState({url:'/home/add-coffee'})
    url = '/home/add-coffee'
  if fromButton? and not fromButton
    if url.indexOf('/home') is 0
      $("button#homebutton").addClass('selected')
    else if url.indexOf('/history') is 0
      $("button#historybutton").addClass('selected')
  $('#page').loadPage(url)

$.fn.inputBehaviour = (id) ->
  $("##{id}").focus(() ->
    if $("##{id}").attr('class') is 'default'
      el = $("##{id}")
      if id is 'email'
        el.replaceWith('<input type="email" id="email" name="email"></input>')
      else if id is 'password'
        el.replaceWith('<input type="password" id="password" name="password"></input>')
      else if id is 'name'
        el.replaceWith('<input type="text" id="name" name="name"></input>')
      $("##{id}").focus()
      $("##{id}").focusout(() ->
        if $("##{id}").attr('class') isnt 'default' and $("##{id}").attr('value') is ''
          el = $("##{id}")
          if id is 'email'
            el.replaceWith('<input class="default" type="text" id="email" value="e-mail"></input>')
          else if id is 'password'
            el.replaceWith('<input class="default" type="text" id="password" value="password"></input>')
          else if id is 'name'
            el.replaceWith('<input class="default" type="text" id="name" value="name"></input>')
        $(this).inputBehaviour(id)
      )
  )

$.fn.extend({
  loadPage: (url) ->
    el = this
    currentUrl = "/index#url=#{$.bbq.getState('url')}"
    $.get(url, (data, status, xhr) ->
      if $.isPlainObject(data)
        data.currentUrl = currentUrl
        processResponse(data)
      else
        newPage = $(data)
        newPage.children().hide()
        sidebarButtons()
        $('#page').replaceWith(newPage)
        $('#page').children().show("fade", {}, 150)
    )
    return el
})
