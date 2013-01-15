doctype 5
html ->
  head ->
    title 'Roast::Index'
    link type:'text/css', rel:'stylesheet', href:'/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
    link type:"text/css", rel:"stylesheet", href:"/css/fonts/stylesheet.css"
    script src:'/js/jquery-1.8.3.min.js'
    script src:'/js/jquery.ba-bbq.min.js'
    script src:'/js/jquery-ui.js'
    script src:'/js/block-ui.js'
  body class:'background', ->
    div class:'navbar', ->
      div class:'center', ->
        div class:'left', style:'visibility:hidden;',  -> 'Roast'
        button class:'navbar', id:'homebutton', href: "/home", -> 'Home'
        button class:'navbar', id:'historybutton', href: "/history", -> 'History'
        div class:'right',  ->
          a href:'/deauth', -> 'Logout'
    div class:'page', id:'page', ->

coffeescript ->
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
          $('#page').replaceWith(newPage)
          $('#page').children().show("fade", {}, 350)
      )
      return el
  })

  $(($) ->
    change = (fromButton) ->
      url = $.bbq.getState('url')
      if not url? or url is '/' or not url or (url is '/login' or url is '/register')
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
