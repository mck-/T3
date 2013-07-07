window.app = angular.module('T3', ['ngSanitize', 'firebase'])

app.config ($routeProvider) ->
  $routeProvider
    .when '/game/:game',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .when '/',
      templateUrl: 'views/splash.html'
      controller: 'NewCtrl'
    .otherwise
      redirectTo: '/'