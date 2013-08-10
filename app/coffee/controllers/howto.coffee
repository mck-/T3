app.controller 'HowToCtrl', ($scope, $location) ->

  $scope.homepage = () ->
    $location.path "/"
