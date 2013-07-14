app.controller 'SplashCtrl', ($scope, $location) ->

  # Clear localstorage
  localStorage.removeItem('player')
  localStorage.removeItem('local')

  $scope.newOnlineGame = () ->
    console.log 'Creating new online game'
    localStorage.player = 1
    $location.path "/#{Math.floor Math.random() * 78343}"

  $scope.newLocalGame = () ->
    console.log 'Creating local game'
    localStorage.local = true
    $location.path "/local"
