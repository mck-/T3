app.controller 'SplashCtrl', ($scope, $location) ->

  # Clear localstorage
  localStorage.removeItem('player')

  $scope.newOnlineGame = () ->
    console.log 'Creating new online game'
    localStorage.player = 1
    $location.path "/#{Math.floor Math.random() * 99999}"

  $scope.newLocalGame = () ->
    console.log 'Creating local game'
    $location.path "/local"

  $scope.howToPlay = () ->
    $location.path "/howto"

  $scope.randomMatch = () ->
    $location.path "/random"
