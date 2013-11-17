class OauthsController < ApplicationController
  skip_before_filter :require_login
  require "net/https"
      
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    cookies[:redirect_path] = request.env["HTTP_REFERER"] unless cookies[:redirect_path]
    login_at(params[:provider])
  end

  def touch
    render status: 200,
      json: {
        user: current_user
      }
  rescue => ex
    render status: 500,
      json: {
        msg: ex.message
      }
  end

  # FIXME: clean up later...
  def verify
    exchange_token_url = "/oauth/access_token?grant_type=fb_exchange_token&client_id=" +
      ENV["FB_APP_ID"] + "&client_secret=" +
      ENV["FB_APP_SECRET"] + "&fb_exchange_token=" +
      params[:short_access_token]

    res          = get_https( exchange_token_url )
    results      = Rack::Utils.parse_nested_query res.body
    access_token = results["access_token"]

    fb_verify_url = URI::encode( "/debug_token?input_token=#{access_token}&access_token=#{access_token}" )
    res           = get_https( fb_verify_url )
    debug_token_result = JSON.parse res.body
    user_id = debug_token_result["data"]["user_id"]

    unless auth = Authentication.where( provider: "facebook", uid: user_id ).first
      fbuser = FbGraph::User.fetch(user_id, :access_token => access_token)

      user = User.new(
        username: fbuser.username,
        email: fbuser.email,
        name: fbuser.name
      )
      if user.save
        auth = Authentication.new(
          user_id: user.id,
          provider: "facebook",
          uid: debug_token_result["data"]["user_id"]
        )

        if auth.save
          reset_session
          session[:user_id] = user.id

          render status: 200,
            json: {
              user: user
            }
          return
        end
      end
    end
  rescue => ex
    render status: 500,
      json: {
        msg: ex.message
      }
  end

  # FIXME: clean up later...
  def get_https( url )
    fb_domain = "graph.facebook.com"

    https = Net::HTTP.new(fb_domain, 443)
    https.use_ssl = true
    https.ca_file = ENV['SSL_CERT_FILE']
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    uri = URI::encode( url )

    res = nil
    https.start {|w|
      res = w.get(uri)
    }
    res
  end
      
  # https://www.compathy.net/oauth/callback?provider=facebook&code=xxxx
  # https://www.compathy.net/oauth/callback?provider=facebook&signed_request=ooooo
  def callback
    provider = params[:provider]
    redirect_path = cookies[:redirect_path] || "/"
    cookies.delete :redirect_path

    if @user = login_from(provider)
      if @user.active?
        @user.refresh_token!( provider, @access_token )

        redirect_to redirect_path, :notice => I18n.t("user.login_success")
      else
        reset_session
        @user = nil
        redirect_to "/", :notice => "you already signed out this service. if you would like to re-signup, please contact us."
      end
    else
      begin
        # NOTE: create_from (Sorcery method) skips validate.
        @user = create_from(provider)

        reset_session # protect from session fixation attack
        auto_login(@user)

        redirect_to "/users/edit"
      rescue => ex
        raise ex.message if Rails.env == 'development'
      end
    end
  end
end
