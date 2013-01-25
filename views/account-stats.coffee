div class:'page', id:'page', ->
  div class: 'center large', ->
    span class:'center large', -> 'User Account Stats'
    table id:'account-stats', ->
      tr ->
        td class:'rank', -> 'Rank'
        td class:'name', -> 'Name'
        td class:'updated', -> 'Last Updated'
        td class:'cups', -> 'Cups/Day'
        td class:'balance', -> 'Balance'
        td class:'recpayment', -> 'Rec. Payment'

coffeescript ->
  $(($) ->
    #$(this).loadAccountStats()
  )
