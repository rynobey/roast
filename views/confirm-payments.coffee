script src:'/partials/adminsummary'
script src:'/partials/loader'

div class:'page', id:'page', ->
  div class: 'center medium', ->
    span class:'center medium', -> 'Confirm Payments'
    table id:'confirm-payments', ->
      tr ->
        td class:'name', -> 'Name'
        td class:'email', -> 'E-mail'
        td class:'amount', -> 'Amount'
        td class:'button', -> 'Received'
  div class: 'center small', ->
    span class:'space', -> 'Stats'
    br()
    span id:'summary', ->

coffeescript ->
  statusData = {}
  paymentData = {}
  timeout = 0
  startIndex = 0
  iPerPage = 5
  endIndex = startIndex + iPerPage
  genPaymentHTML = (name, email, amount, id, empty) ->

    if not empty? or (empty? and not empty)
      html = """
        <tr>
          <td class="name">#{name}</td>
          <td class="email">#{email}</td>
          <td class="amount">R #{amount}</td>
          <td class="button">
            <button type="button" id="#{id}">Yes</button>
          </td>
        </tr>
      """
    else if empty? and empty
      html = """
        <tr>
          <td class="name"></td>
          <td class="email"></td>
          <td class="amount"></td>
          <td class="button"></td>
        </tr>
      """
    return html

  restoreStats = () ->
    timeout = 0
    $.unblockUI({fadeOut:100})
    statusAction()

  restoreList = () ->
    timeout = 0
    $.unblockUI({fadeOut:100})
    listAction()

  loadStatus = () ->
    $.ajax({
      url: '/users/summary'
      success: (data) ->
        statusData = data
        setTimeout(restoreStats, timeout)
      error: () ->
        setTimeout(restoreStats, timeout)
      dataType: 'json'
    })

  loadPayments = () ->
    $.ajax({
      url: '/users/payments'
      success: (data) ->
        paymentData = data
        setTimeout(restoreList, timeout)
      error: () ->
        setTimeout(restoreList, timeout)
      dataType: 'json'
    })

  statusAction = () ->
    if statusData? and statusData.balance? and statusData.totCoffee?
      $('span#summary').replaceWith(templates.adminsummary({
        balance:statusData.balance,
        totSpent:statusData.totSpent,
        totCoffee:statusData.totCoffee,
        totMilk:statusData.totMilk,
        totSugar:statusData.totSugar
      }))
    else
      $('span#summary').replaceWith(templates.adminsummary({
        balance:'-',
        totSpent:'-',
        totCoffee:'-',
        totMilk:'-',
        totSugar:'-'
      }))

  listAction = () ->
    if paymentData?
      $('table#confirm-payments tr+tr').remove()
      current = startIndex
      for payment in paymentData
        if not payment.confirmed
          $('table#confirm-payments').append(genPaymentHTML(payment.name, payment.email, payment.amount, payment.id))
          current = current + 1
          if current >= endIndex
            break
      while current < endIndex
        $('table#confirm-payments').append(genPaymentHTML('','','','', true))
        current = current + 1
    else
      console.log "error"
    $('table#confirm-payments').find('button').on('click', (e) ->
      $.blockUI({
        fadeIn: 100,
        message: $(templates.loader()),
        css: {
          left: '48%',
          width: '0px',
          opacity: 0.6,
          border: '0px',
          color: '#FFFFFF'
        }
      })
      $.post('/users/payments', "id=#{$(this).attr('id')}", (data) ->
        loadPayments()
        loadStatus()
      )
    )

  $(($) ->
    loadPayments()
    loadStatus()
  )
