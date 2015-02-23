class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /sign_in
  def new
    super
  end

  # GET /sign_out
  def destroy
    super
  end
end
