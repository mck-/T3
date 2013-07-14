window.app = angular.module('T3', ['firebase'])

app.config ($routeProvider) ->
  $routeProvider
    .when '/:game',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: "/#{Math.floor Math.random() * 7832684}"
