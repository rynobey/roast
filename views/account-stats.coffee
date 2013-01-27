div class:'page', id:'page', ->
  div class: 'center large', ->
    span class:'center large', -> 'User Account Stats'
    table id:'account-stats', ->
      tr ->
        td class:'name', -> 'Name'
        td class:'numeric', ->
          span -> 'Last Updated'
        td class:'numeric', ->
          span -> 'Cups/Day'
        td class:'numeric', ->
          span -> 'Balance'
        td class:'numeric', ->
          span -> 'Rec. Payment'

coffeescript ->
  $(($) ->
    $(this).loadAccountStats()
  )
