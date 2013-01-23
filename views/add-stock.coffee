script src:'/partials/adminsummary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center medium', ->
    form class:'add-stock', action: '/purchases', method: 'post', ->
      span class:'center medium', -> 'Add Stock'
      table class:'stock', ->
        tr class:'stock-header', ->
          td -> 'Type'
          td -> 'Amount'
          td -> 'Units'
          td -> 'Cost'
        tr ->
          td ->
            select class:'stock-type', ->
              option value:'Coffee', -> 'Coffee'
              option value:'Milk', -> 'Milk'
              option value:'Sugar', -> 'Sugar'
          td ->
            input type: 'text', id:'amount', name:'amount', value:'1', onkeypress:"return event.keyCode!=13;"
          td class:'unit-value', ->
            'kg'
          td ->
            span class:'stock-cost', ->
              text 'R'
              input class:'stock-cost', type:'text', id:'cost', name:'cost', value:'0', onkeypress:"return event.keyCode!=13;"
      input type: 'hidden', id: 'type', name: 'type', value: 'Coffee'
      input type: 'hidden', id: 'operation', name: 'operation', value: 'add'
      button type: 'button',->
        i class:'icon-thumbs-up', ->
        text 'Submit'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  $(($) ->
    $('input#amount').attr('autocomplete', 'off')
    $('input#cost').attr('autocomplete', 'off')
    $('span.stock-cost').click(() ->
      $('input.stock-cost').focus()
    )
    $('div.center span.input').on('click', () ->
      $('div.center input#params').focus()
    )
    $('select.stock-type').change(() ->
      $(this).setUnits()
    )
    $(document).ready(() ->
      $(this).setUnits()
      $(this).loadAdminStats()
    )
  )
