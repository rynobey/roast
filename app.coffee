express = require('express')
app = express()

app.get('/', (req, res) ->
  res.send('HELLO WORLD!')
)

app.listen(3000)
