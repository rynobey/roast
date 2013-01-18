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

coffeescript ->
  paymentData = {}
  timeout = 0
  genPaymentHTML = (name, email, amount, id) ->
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
    return html

  restoreList = () ->
    timeout = 0
    $.unblockUI({fadeOut:100})
    action()

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

  action = () ->
    if paymentData?
      $('tr+tr').remove()
      for payment in paymentData
        if not payment.confirmed
          $('table#confirm-payments').append(genPaymentHTML(payment.name, payment.email, payment.amount, payment.id))
    else
      console.log "error"
    $('table#confirm-payments').find('button').on('click', (e) ->
      $.post('/users/payments', "id=#{$(this).attr('id')}", (data) ->
        loadPayments()
      )
    )

  $(($) ->
    loadPayments()
  )
