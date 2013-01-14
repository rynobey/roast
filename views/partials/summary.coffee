span id:'summary', ->
  table class:'summary', ->
    tr ->
      td class:'key', -> 'Current Balance'
      td class:'unit', -> 'R'
      td class:'value', -> "#{@balance}"
    tr ->
      td class:'key', -> 'Total Spent'
      td class:'unit', -> 'R'
      td class:'value', -> "#{@totSpent}"
    tr ->
      td class:'key', -> 'Total Coffees'
      td class:'unit', -> ''
      td class:'value', -> "#{@totCoffees}"
