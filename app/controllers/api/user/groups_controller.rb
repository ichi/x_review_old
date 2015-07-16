class Api::User::GroupsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i(show)

  def index
    @groups = Group.by_user(current_user)
  end

  def show
  end


  private

    def set_group
      @group = Group.by_user(current_user).find params[:id]
    end
end
