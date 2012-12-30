div class:'center', ->
  img class:'logo', src:'/img/logo.jpg'
  button class:'button', id:'homebutton', onClick: "parent.location='/home'", -> 'HOME'
  button class:'button', id:'coffeesbutton', onClick: "parent.location='/coffees'", -> 'COFFEES'
  button class:'button', id:'paymentsbutton', onClick: "parent.location='/payments'", -> 'PAYMENTS'
  button class:'button', id:'purchasesbutton', onClick: "parent.location='/purchases'", -> 'PURCHASES'
  button class:'button', id:'logoutbutton', onClick: "parent.location='/deauth'", -> 'LOGOUT'
