app.controller 'NewCtrl', ($scope, $location) ->

  $scope.online = () ->
    $location.path "/game/#{Math.floor Math.random() * 7832684}"
