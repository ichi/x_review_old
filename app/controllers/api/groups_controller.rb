class Api::GroupsController < Api::ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)
  before_action :set_group, only: %i(show update destroy)
  before_action :check_editable, only: %i(update destroy)

  # GET /api/groups
  def index
    @groups = Group.all
  end

  # GET /api/groups/:id
  validates :show do
    integer :id, required: true
  end
  def show
  end

  # POST /api/groups
  validates :create do
    object :group, required: true do
      string :name, strong: true, required: true
    end
  end
  def create
    @group = Group.new(group_params)
    @group.groups_users << GroupsUser.new(user: current_user, role: Role::ADMIN)

    if @group.save
      render :show, status: :created
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/groups/:id
  validates :update do
    integer :id, required: true
    object :group, required: true do
      string :name, strong: true
    end
  end
  def update
    if @group.update(group_params)
      render :show, status: :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/groups/:id
  validates :delete do
    integer :id, required: true
  end
  def destroy
    @group.destroy
    head :no_content
  end

  private

    def set_group
      @group = Group.find params[:id]
    end

    def group_params
      permitted_params[:group]
    end

    def check_editable
      forbidden 'You cannot edit this group.'  unless @group.editable?(current_user)
    end
end
