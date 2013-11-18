'use strict';

var myApp = angular.module('compathy2App', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'config'
])
  .config(function ($locationProvider, $routeProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/about', {
        templateUrl: 'views/about.html',
        controller: 'AboutCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
