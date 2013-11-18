'use strict'

myApp.controller 'MainCtrl', ['$scope', '$http', 'FB_APP_ID', ($scope, $http, FB_APP_ID) ->
  $scope.currentUser = null

  $scope.init = ->
    $http(
      url: "/api/oauth/fetch_user"
      method: "GET"
    ).success( (data) ->
      $scope.currentUser = data.user
    ).error( (msg) ->
      alert msg
    )
    $scope.initFb()

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
        $scope.short_access_token = short_access_token
        $scope.cyVerify()
      else
        console.log 'User cancelled login or did not fully authorize.'

  $scope.logoutFb = ->
    $scope.currentUser = null
    $http(
      url: "/api/oauth/logout"
      method: "GET"
    ).success( ->
      # do nothing
    ).error( (msg) ->
      alert msg
    )

  $scope.cyVerify = ->
    $http(
      url: "/api/oauth/verify"
      method: "GET"
      params:
        short_access_token: $scope.short_access_token
    ).success( (data) ->
      $scope.currentUser = data.user
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
]

