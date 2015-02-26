class Api::ApplicationController < ApplicationController

  # @override Devise::Controllers::Helpers#:authenticate_user!
  def authenticate_user!
    render json: {'error' => 'authentication error'}, status: :forbidden unless current_user
  end
end
