app.controller 'SplashCtrl', ($scope, $location) ->

  # Reset previous player number
  localStorage.removeItem('player')

  $scope.newOnlineGame = () ->
    console.log 'Creating new online game'
    localStorage.player = 1
    $location.path "/#{Math.floor Math.random() * 78343}"
