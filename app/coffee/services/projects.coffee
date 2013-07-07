app.factory 'T3Factory', (angularFire) ->
  link: (scope, variable, type, id) ->
    url = 'https://3t.firebaseio.com/' + id
    angularFire url, scope, variable, type