class Api::ApplicationController < ApplicationController

  respond_to :json

  # @override Devise::Controllers::Helpers#:authenticate_user!
  def authenticate_user!
    forbidden unless current_user
  end

  def forbidden(err_msg = 'authentication error')
    render json: {'error' => err_msg}, status: :forbidden
  end
end
