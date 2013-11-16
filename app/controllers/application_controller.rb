class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter :set_basic_auth_env_staging
  before_filter :check_user_agent_for_mobile

  def require_authentication
    unless current_user
      respond_to do |format|
        format.html { redirect_to root_path, notice: I18n.t("notification.please_login") }
        format.json { render json: I18n.t("notification.please_login"), status: :unprocessable_entity }
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def set_breadcrumb
    add_breadcrumb I18n.t("common.top"), :root_path
  end

  def ready_to_mail?
    mail_config = ::Rails.application.config.action_mailer.smtp_settings
    mail_config[:user_name].present? and mail_config[:password].present?
  end


  protected
    def not_authenticated
      redirect_to login_path, :alert => "Please login first."
    end

    def set_basic_auth
      authenticate_or_request_with_http_basic('Enter Password') do |u, p|
        u == ENV['BASIC_ID'] && p == ENV['BASIC_PASS']
      end
    end

    def set_basic_auth_env_staging
      set_basic_auth if Rails.env.staging?
    end

    # default to ja
    def set_locale
      if current_user
        if current_user.locale =~ /ja/
          I18n.locale = :ja
        else
          I18n.locale = :en
        end
      else
        if cookies[:locale]
          if cookies[:locale] =~ /en/
            I18n.locale = :en
          else
            I18n.locale = :ja
          end
        else
          I18n.locale = :ja
        end
      end
    end

    def check_user_agent_for_mobile
      if ua = request.env["HTTP_USER_AGENT"]
        if(ua.include?('Mobile') || ua.include?('Android'))
          redirect_to "http://launchrock.compathy.net/"
        end
      end
    end
end
