app.factory 'T3Factory', (angularFire) ->
  url = 'https://3t.firebaseio.com/'
  link: (scope, variable, type) ->
    angularFire url, scope, variable, type