window.app = angular.module('T3', ['firebase'])

app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/splash.html'
      controller: 'SplashCtrl'
    .when '/:game',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: "/"
