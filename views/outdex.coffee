doctype 5
html ->
  head ->
    title 'Roast::Index'
    link type:'text/css', rel:'stylesheet', href:'/css/jquery-ui.css'
    link type:'text/css', rel:'stylesheet', href:'/css/stylesheet.css'
    link type:"text/css", rel:"stylesheet", href:"/css/fonts/stylesheet.css"
    link type:"text/css", rel:"stylesheet", href:"/css/icons/package1/css/icons.css"
    #text global.css('jquery-ui.css')
    #text global.css('stylesheet.css')
    #text global.css('fonts/stylesheet.css')
    #text global.css('icons/package1/css/icons.css')
    text global.js('jquery-1.8.3.min.js')
    text global.js('jquery.ba-bbq.min.js')
    text global.js('jquery-ui.js')
    text global.js('block-ui.js')
    text global.js('scripts')
    text global.js('sha1.js')

  body class:'background', ->
    div class:'navbar', ->
      div class:'center', ->
        div class:'left', style:'visibility:hidden;',  -> 'Roast'
        button class:'navbar', id:'loginbutton', href: "/login", ->
          i class:'icon-key-1', ->
          span class:'title', -> 'Login'
        button class:'navbar', id:'registerbutton', href: "/register", ->
          i class:'icon-edit-1', ->
          span class:'title', -> 'Register'
        div class:'right', style:'visibility:hidden;',  ->
          a href:'/deauth', -> 'Logout'
    div class:'page-container', ->
      div class:'sidebar', id:'sidebar-left', ->
      div class:'page', id:'page', ->
      div class:'sidebar', id:'sidebar-right', ->
        div class:'info', ->
          span -> 'coffee'
      div style:'text-align:center;', -> 'Built for webkit/moz based browsers using NodeJS. (Unstable in IE!)'

coffeescript ->
  $(($) ->
    $(this).sidebarButtons()
    $(this).outerChange(false)
    $(document).ready(() ->
      $('body.background').show("fade", {}, 150)
      $(window).unbind('hashChange')
      $(window).bind('hashChange', $(this).outerChange)
      $('div.navbar').find('button').on('click', (e) ->
        $(this).navButtonEvent(this, e)
      )
    )
  )
