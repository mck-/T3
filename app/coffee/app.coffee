window.app = angular.module('T3', ['ngSanitize', 'firebase'])

app.config ($routeProvider) ->
  $routeProvider
    .when '/game',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: '/game'