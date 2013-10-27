$ = jQuery
timeout = 500
statusData = {}
paymentData = {}
accountsData = {}
startIndex = 0
iPerPage = 5
iPerPageAccount = 17
endIndex = startIndex + iPerPage
endIndexAccounts = startIndex + iPerPageAccount

processResponse = (data) ->
  if data.success
    if data.redirect?
      $.bbq.pushState({url:data.redirect})
      $(window).trigger('hashChange')
    if data.reload?
      $.bbq.pushState({url:data.currentUrl})
      $(window).trigger('hashChange')

isOnAdminHome = () ->
  if $.bbq.getState('url').indexOf('/home/add-stock') is 0 or $.bbq.getState('url').indexOf('/home/confirm-payments') is 0 or $.bbq.getState('url').indexOf('/home/account-stats') is 0
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
  $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='accounts' href='/home/account-stats'><i class='icon-list-alt'></button>")

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
      else if url.indexOf('/home/account-stats') is 0
        $("button#accounts").addClass('selected')
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

genPaymentHTML = (name, email, amount, id, empty) ->
  if not empty? or (empty? and not empty)
    html = """
      <tr><td class="name">#{name}</td><td class="email">#{email}</td><td class="amount">R #{amount}</td><td class="button"><button type="button" id="#{id}">Yes</button></td></tr>
    """
  else if empty? and empty
    html = """
      <tr><td class="name"></td><td class="email"></td><td class="amount"></td><td class="button"></td></tr>
    """
  return html

genAccountHTML = (name, lastUpdated, cPerD, totCups, balance, recPayment, empty) ->
  if not empty? or (empty? and not empty)
    html = """
      <tr><td class="name">#{name}</td><td class="numeric">#{lastUpdated} Day(s)</td><td class="numeric">#{cPerD}</td><td class="numeric">#{totCups}</td><td class="numeric">R #{balance}</td><td class="numeric">R #{recPayment}</td></tr>
    """
  else if empty? and empty
    html = """
      <tr><td class="name"></td><td class="numeric"></td><td class="numeric"></td><td class="numeric"></td><td class="numeric"></td><td class="numeric"></td></tr>
    """

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
    adminButtonEvent()
  )

paymentListAction = () ->
  if paymentData?
    $('table#confirm-payments tr+tr').remove()
    current = startIndex
    for payment in paymentData
      if not payment.confirmed
        $('table#confirm-payments').append(genPaymentHTML(payment.name, payment.email, payment.amount, payment.id))
        current = current + 1
        if current >= endIndex
          break
    while current < endIndex
      $('table#confirm-payments').append(genPaymentHTML('','','','', true))
      current = current + 1
  else
  $('table#confirm-payments').find('button').on('click', (e) ->
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
    $.post('/users/payments', "id=#{$(this).attr('id')}", (data) ->
      loadPayments()
      loadAdminStats()
    )
  )

accountStatsAction = () ->
  if accountsData?
    $('table#account-stats tr+tr').remove()
    current = startIndex
    for item in accountsData
      $('table#account-stats').append(genAccountHTML(item.name, item.lastUpdated, item.cupsPerDay, item.totCups, item.balance, item.recPayment))
      current = current + 1
      if current >= endIndexAccounts
        break
    while current < endIndexAccounts
      $('table#account-stats').append(genAccountHTML('','','','', '', '', true))
      current = current + 1

loadPayments = () ->
  $.ajax({
    url: '/users/payments'
    success: (data) ->
      paymentData = data
      paymentListAction()
      setTimeout(unblockUI, timeout)
    error: () ->
      paymentListAction()
      setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadPayments = loadPayments

loadUserStats = () ->
  $.ajax({
    url: '/users/summary'
    success: (data) ->
      statusData = data
      userStatsAction()
      setTimeout(unblockUI, timeout)
    error: () ->
      userStatsAction()
      setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadUserStats = loadUserStats

loadAdminStats = () ->
  $.ajax({
    url: '/users/summary'
    success: (data) ->
      statusData = data
      adminStatsAction()
      setTimeout(unblockUI, timeout)
    error: () ->
      adminStatsAction()
      setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadAdminStats = loadAdminStats

loadAccountStats = () ->
  $.ajax({
    url: '/users/account-stats'
    success: (data) ->
      accountsData = data
      accountStatsAction()
      setTimeout(unblockUI, timeout)
    error: () ->
      accountStatsAction()
      setTimeout(unblockUI, timeout)
    dataType: 'json'
  })

$.fn.loadAccountStats = loadAccountStats

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
    if $('button.add-coffee').is(':focus') or $('button.add-coffee').is(':hover')
      $.post('/users/coffees', $('form.add-coffee').serialize(), (data) ->
        loadUserStats()
      )
    else if $('button.add-milk').is(':focus') or $('button.add-milk').is(':hover')
      $.post('/users/milk', $('form.add-milk').serialize(), (data) ->
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
        $('input#password').keypress((e) ->
          if $('form.login-register').find('input').attr('class') is 'default'
            e.preventDefault()
          else if e.which is 13
            $('form.login-register').find('input#hash').attr('value',
              hex_sha1($('form.login-register').find('input#password').attr('value')))
            $('form.login-register').find('input#password').attr('value', '')
            $('form.login-register').submit()
        )
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
