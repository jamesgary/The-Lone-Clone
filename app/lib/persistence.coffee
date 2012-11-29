define ->
  get: (dataName) ->
    JSON.parse(localStorage.getItem(dataName))
  set: (dataName, data) ->
    localStorage.setItem(dataName, JSON.stringify(data))
