'use strict'

myApp.controller 'MainCtrl', ['$scope', 'FB_APP_ID', '$http', ($scope, FB_APP_ID, $http) ->
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

  $scope.loginFb = ->
    FB.login (response) ->
      if (response.authResponse)
        short_access_token = FB.getAuthResponse()['accessToken']
        console.log 'Welcome!  Fetching your information.... '
        FB.api '/me', (response) ->
          $scope.$apply ->
            $scope.user = response
            $scope.short_access_token = short_access_token
      else
        console.log 'User cancelled login or did not fully authorize.'

  $scope.cyVerify = ->
    $http(
      url: "/api/oauth/verify"
      method: "GET"
      params:
        short_access_token: $scope.short_access_token
    ).success( (data) ->
      if (data.success)
        alert "success"
      else
        alert data
    ).error( (msg) ->
      alert msg
    )

  $scope.cyTouch = ->
    $http(
      url: "/api/oauth/touch"
      method: "GET"
    ).success( (data) ->
      alert data
    ).error( (msg) ->
      alert msg
    )

  $scope.initFb()
]

