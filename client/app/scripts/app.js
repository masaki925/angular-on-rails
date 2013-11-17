'use strict';

var myApp = angular.module('compathy2App', [
  'config',
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute'
])
  .config(function ($locationProvider, $routeProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
