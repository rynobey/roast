doctype 5
html ->
  head ->
    title 'Roast::Index'
    link type:'text/css', rel:'stylesheet', href:'/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
    link type:"text/css", rel:"stylesheet", href:"/css/fonts/stylesheet.css"
    link type:"text/css", rel:"stylesheet", href:"/css/icons/package1/css/icons.css"
    script src:'/js/jquery-1.8.3.min.js'
    script src:'/js/jquery.ba-bbq.min.js'
    script src:'/js/jquery-ui.js'
    script src:'/js/block-ui.js'
  body class:'background', ->
    div class:'navbar', ->
      div class:'center', ->
        div class:'left', style:'visibility:hidden;',  -> 'Roast'
        button class:'navbar', id:'homebutton', href: "/home", ->
          i class:'icon-home-2', ->
          span class:'title', -> 'Home'
        button class:'navbar', id:'historybutton', href: "/history", ->
          i class:'icon-back-in-time', ->
          span class:'title', -> 'History'
        div class:'right',  ->
          a href:'/deauth', -> 'Logout'
    div class:'page-container', ->
      div class:'sidebar', id:'sidebar-left', ->
      div class:'page', id:'page', ->
      div class:'sidebar', id:'sidebar-right', ->

coffeescript ->
  processResponse = (data) ->
    if data.success
      if data.redirect?
        $.bbq.pushState({url:data.redirect})
        $(window).trigger('hashChange')
      if data.reload?
        $.bbq.pushState({url:data.currentUrl})
        $(window).trigger('hashChange')

  $.fn.extend({
    contentLoad: (url) ->
      el = this
      currentUrl = "/index#url=#{$.bbq.getState('url')}"
      $.get(url, (data, status, xhr) ->
        if $.isPlainObject(data)
          data.currentUrl = currentUrl
          processResponse(data)
        else
          newPage = $(data)
          newPage.children().hide()
          $('div#sidebar-left').find('button').remove()
          if $.bbq.getState('url').indexOf('/home/add-stock') is 0 or $.bbq.getState('url').indexOf('/home/confirm-payments') is 0
            $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='stock' href='/home/add-stock'><i class='icon-cart'></i></button>")
            $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='payments' href='/home/confirm-payments'><i class='icon-dollar'></button>")
            if url.indexOf('/home/add-stock') is 0
              $("button#stock").addClass('selected')
            else if url.indexOf('/home/confirm-payments') is 0
              $("button#payments").addClass('selected')
          else if $.bbq.getState('url').indexOf('/home/add-coffee') is 0 or $.bbq.getState('url').indexOf('/home/add-payment') is 0 or $.bbq.getState('url').indexOf('/home/stock-payment') is 0
            $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='coffee' href='/home/add-coffee'><i class='icon-coffee'></i></button>")
            $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='stock' href='/home/stock-payment'><i class='icon-cart'></i></button>")
            $('div#sidebar-left').append("<button type='button' class='sidebar-button' id='payment' href='/home/add-payment'><i class='icon-dollar'></i></button>")
            if url.indexOf('/home/add-coffee') is 0
              $("button#coffee").addClass('selected')
            else if url.indexOf('/home/stock-payment') is 0
              $("button#stock").addClass('selected')
            else if url.indexOf('/home/add-payment') is 0
              $("button#payment").addClass('selected')
          $('div#sidebar-left').find('button').on('click', (e) ->
            e.preventDefault()
            href = $(this).attr('href')
            $.bbq.pushState({url:href})
            $(window).trigger('hashChange')
            $(this).siblings('button').removeClass('selected')
            $(this).bind('mouseleave', ->
              $(this).addClass('selected')
              $(this).unbind('mouseleave')
            )
            return false
          )
          $('#page').replaceWith(newPage)
          $('#page').children().show("fade", {}, 350)
      )
      return el
  })

  $(($) ->
    $('div#sidebar-left').find('button').remove()
    change = (fromButton) ->
      url = $.bbq.getState('url')
      if not url? or url is '/' or url is '/home' or not url or (url is '/login' or url is '/register')
        $.bbq.pushState({url:'/home/add-coffee'})
        url = '/home/add-coffee'
      if fromButton? and not fromButton
        if url.indexOf('/home') is 0
          $("button#homebutton").addClass('selected')
        else if url.indexOf('/history') is 0
          $("button#historybutton").addClass('selected')
      $('#page').contentLoad(url)

    $(window).bind('hashChange', change)
    $(document).ready(() ->
      $('body.background').show("fade", {}, 300)
    )
    $('div.navbar').find('button').on('click', (e) ->
      e.preventDefault()
      href = $(this).attr('href')
      $.bbq.pushState({url:href})
      $(window).trigger('hashChange')
      $(this).siblings('button').removeClass('selected')
      $(this).bind('mouseleave', ->
        $(this).addClass('selected')
        $(this).unbind('mouseleave')
      )
      return false
    )
    change(false)
  )
