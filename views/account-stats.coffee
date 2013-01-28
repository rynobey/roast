div class:'page', id:'page', ->
  div class: 'center large', ->
    span class:'center large', -> 'User Account Stats'
    table id:'account-stats', ->
      tr ->
        td class:'name', -> 'Name'
        td class:'numeric', ->
          span -> 'Updated'
        td class:'numeric', ->
          span -> 'Cups/Day'
        td class:'numeric', ->
          span -> 'Total Cups'
        td class:'numeric', ->
          span -> 'Balance'
        td class:'numeric', ->
          span -> 'Rec. Paym.'

coffeescript ->
  $(($) ->
    $(this).loadAccountStats()
  )
