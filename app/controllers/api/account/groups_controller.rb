class Api::Account::GroupsController < Api::ApplicationController
  before_action :authenticate_user!

  # GET /api/account/groups
  def index
    @groups = current_user.groups
    render 'api/groups/index'
  end
end
