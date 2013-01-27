script src:'/partials/adminsummary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center medium', ->
    span class:'center medium', -> 'Confirm Payments'
    table id:'confirm-payments', ->
      tr ->
        td class:'name', -> 'Name'
        td class:'email', -> 'E-mail'
        td class:'amount', ->
          span -> 'Amount'
        td class:'button', -> 'Received'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  $(($) ->
    $(this).loadPayments()
    $(this).loadAdminStats()
  )
