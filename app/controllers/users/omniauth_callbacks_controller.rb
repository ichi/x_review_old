class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth, current_user)

    if @user.persisted?
      flash[:notice] = 'サインインしました'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.twitter'] = auth
      redirect_to root_url, alert: 'サインインに失敗しました'
    end

  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  protected

    # The path used when omniauth fails
    def after_omniauth_failure_path_for(scope)
      root_path
    end
end
