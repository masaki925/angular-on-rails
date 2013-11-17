'use strict'

myApp.controller 'MainCtrl', ['$scope', 'FB_APP_ID', ($scope, FB_APP_ID) ->
  $scope.user = null
  $scope.awesomeThings = [
    'HTML5 Boilerplate',
    'AngularJS',
    'Karma hoge'
  ]

  $scope.initFb = ->
    if(typeof FB == 'undefined')
      $.ajaxSetup(cache: true)
      $.getScript '//connect.facebook.net/en_US/all.js', ->
        FB.init(
          appId: FB_APP_ID
          xfbml: true
          channelUrl: 'http://compathy.masaki925.com:9000/oauth/callback?provider=facebook'
        )

  $scope.getFb = ->
    FB.login (response) ->
      if (response.authResponse)
        console.log 'Welcome!  Fetching your information.... '
        FB.api '/me', (response) ->
          $scope.$apply ->
            $scope.user = response
      else
        console.log 'User cancelled login or did not fully authorize.'

  $scope.initFb()
]

