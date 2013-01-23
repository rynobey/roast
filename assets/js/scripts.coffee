$ = jQuery

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
  $('div#sidebar-left').find('button').on('click', (e) ->
    return sidebarButtonEvent(this, e)
  )

$.fn.sidebarButtons = sidebarButtons

navButtonEvent = (el, event) ->
  event.preventDefault()
  href = $(el).attr('href')
  $.bbq.pushState({url:href})
  $(window).trigger('hashChange')
  $(el).siblings('button').removeClass('selected')
  $(el).bind('mouseleave', ->
    $(el).addClass('selected')
    $(el).unbind('mouseleave')
  )
  return false

$.fn.navButtonEvent = navButtonEvent

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
