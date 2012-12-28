div ->
  if @rows?
    table align:"center", border: '1', ->
      for row in @rows
        tr ->
          for column in row.columns
            td align:"center", -> " #{column} "
