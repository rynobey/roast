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
    script type:'text/javascript', src:'/js/sha1.js'

  body class:'background', ->
    div class:'navbar', ->
      div class:'center', ->
        div class:'left', style:'visibility:hidden;',  -> 'Roast'
        button class:'navbar', id:'loginbutton', href: "/login", -> 'Login'
        button class:'navbar', id:'registerbutton', href: "/register", -> 'Register'
        div class:'right', style:'visibility:hidden;',  ->
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
          $('#page').replaceWith(newPage)
          $('#page').children().show("fade", {}, 350)
      )
      return el
  })

  $(($) ->
    $('div#sidebar-left').find('button').remove()
    change = (fromButton) ->
      url = $.bbq.getState('url')
      if not url? or not url or (url isnt '/login' and url isnt '/register')
        $.bbq.pushState({url:'/login'})
        url = '/login'
      if fromButton? and not fromButton
        $("button[href='#{url}']").addClass('selected')
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
