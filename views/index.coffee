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
  body class:'background', ->
    div class:'navbar', ->
      div class:'center', ->
        div class:'left', style:'visibility:hidden;',  -> 'Roast'
        button type:'button', class:'navbar', id:'homebutton', href: "/home", ->
          i class:'icon-home-2', ->
          span class:'title', -> 'Home'
        button type:'button', class:'navbar', id:'historybutton', href: "/history", ->
          i class:'icon-back-in-time', ->
          span class:'title', -> 'History'
        div class:'right',  ->
          a href:'/deauth', -> 'Logout'
    div class:'page-container', ->
      div class:'sidebar', id:'sidebar-left', ->
      div class:'page', id:'page', ->
      div class:'sidebar', id:'sidebar-right', ->

coffeescript ->
  $(($) ->
    $(this).sidebarButtons()
    $(this).innerChange(false)
    $(document).ready(() ->
      $('body.background').show("fade", {}, 150)
      $(window).unbind('hashChange')
      $(window).bind('hashChange', $(this).innerChange)
      $('div.navbar').find('button').on('click', (e) ->
        $(this).navButtonEvent(this, e)
      )
    )
  )
