class Api::ApplicationController < ApplicationController
  respond_to :json

  rescue_from WeakParameters::ValidationError do |exception|
    bad_request(exception.message)
  end

  # @override Devise::Controllers::Helpers#:authenticate_user!
  def authenticate_user!
    forbidden unless current_user
  end

  def forbidden(err_msg = 'authentication error')
    render json: {'error' => err_msg}, status: :forbidden
  end

  def bad_request(err_msg = 'bad request')
    render json: {'error' => err_msg}, status: :bad_request
  end
end
