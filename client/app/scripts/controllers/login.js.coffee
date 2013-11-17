
myApp.controller "LoginCtrl", ($window) ->
  CLIENT_ID   = 488643514548396
  PROTOCOL    = "http"
  HOSTNAME    = "compathy.masaki925.com:3000"
  PERMISSIONS = "email%2Cuser_birthday%2Cuser_about_me%2Cuser_education_history%2Cuser_work_history%2Cuser_location%2Cuser_status%2Cfriends_status%2Cfriends_location%2Cfriends_photos%2Cpublish_actions%2Cread_stream"

  $window.location = "https://www.facebook.com/dialog/oauth?response_type=code&client_id=" + CLIENT_ID + "&redirect_uri=" + PROTOCOL + "%3A%2F%2F" + HOSTNAME + "%2Fapi%2Foauth%2Fcallback%3Fprovider%3Dfacebook&scope=" + PERMISSIONS + "&display=page"

