doctype 5
html ->
  head ->
    title 'Roast::Index'
    script src:'/js/jquery-1.8.3.min.js'
    script src:'/js/jquery-ui.js'
    script src:'/js/jquery.ba-bbq.min.js'
    link rel:'stylesheet',  href:'/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
    link rel:"stylesheet", type:"text/css", href:"http://fonts.googleapis.com/css?family=Great+Vibes"
  body class: 'background', ->
    div class:'tabs navbar', id:'navbar', ->
      div class:'center', ->
        #img class:'logo', src:'/img/logo.jpg'
        button class:'button', id:'homebutton', href: "/home", -> 'Home'
        button class:'button', id:'coffeesbutton', href: "/coffees", -> 'Coffees'
        button class:'button', id:'paymentsbutton', onClick: "parent.location='/payments'", -> 'Payments'
        button class:'button', id:'purchasesbutton', onClick: "parent.location='/purchases'", -> 'Purchases'
        button class:'button', id:'logoutbutton', onClick: "parent.location='/deauth'", -> 'Logout'
    div class:'page', id:'page', ->

coffeescript ->

  $.fn.extend({
    contentLoad: (url) ->
      el = this
      $.get(url, (data, status, xhr) ->
        if $.isPlainObject(data)
          processResponse(data)
        else
          $('#page').replaceWith($(data).hide().show("fade", {}, 400))
      )
      return el
  })

  $(($) ->
    $(document).ready(() ->
      $('body.background').show("fade", {}, 300)
    )
    processResponse = (data) ->
      if data.success
        if data.redirect?
          $.bbq.pushState({url:data.redirect})
          $(window).trigger('hashChange')
        if data.reload? then location.reload(true)

    tabs = $('.tabs')
    buttonSelector = 'button.button'
    tabs.find(buttonSelector).on('click', (e) ->
      console.log "clicked"
      e.preventDefault()
      href = $(this).attr('href')
      $.bbq.pushState({url:href})
      $(window).trigger('hashChange')
      $(this).siblings('button.button').removeClass('selected')
      $(this).bind('mouseleave', ->
        $(this).addClass('selected')
        $(this).unbind('mouseleave')
      )
      return false
    )
    change = (fromButton) ->
      url = $.bbq.getState('url')
      if not url? or url is '/' or not url
        url = '/home'
      if fromButton? and not fromButton
        $("button[href='#{url}']").addClass('selected')
      $('#page').contentLoad(url)
    $(window).bind('hashChange', change)
    change(false)
  )
