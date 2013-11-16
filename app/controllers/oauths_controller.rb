class OauthsController < ApplicationController
  skip_before_filter :require_login
      
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    cookies[:redirect_path] = request.env["HTTP_REFERER"] unless cookies[:redirect_path]
    login_at(params[:provider])
  end
      
  def callback
    provider = params[:provider]
    redirect_path = cookies[:redirect_path] || root_path
    cookies.delete :redirect_path

    if @user = login_from(provider)
      if @user.active?
        @user.refresh_token!( provider, @access_token )

        redirect_to redirect_path, :notice => I18n.t("user.login_success")
      else
        reset_session
        @user = nil
        redirect_to root_path, :notice => "you already signed out this service. if you would like to re-signup, please contact us."
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
