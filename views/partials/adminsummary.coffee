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
      td class:'key', -> 'Total Coffee(kg)'
      td class:'unit', -> ''
      td class:'value', -> "#{@totCoffee}"
    tr ->
      td class:'key', -> 'Total Milk(litre)'
      td class:'unit', -> ''
      td class:'value', -> "#{@totMilk}"
    tr ->
      td class:'key', -> 'Total Sugar(kg)'
      td class:'unit', -> ''
      td class:'value', -> "#{@totSugar}"
