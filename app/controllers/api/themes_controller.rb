class Api::ThemesController < Api::ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)
  before_action :set_theme, only: %i(show update destroy)
  before_action :check_editable, only: %i(update destroy)

  # GET /api/themes
  def index
    @themes = Theme.all
  end

  # GET /api/themes/1
  validates :show do
    integer :id, required: true
  end
  def show
  end

  # POST /api/themes
  validates :create do
    object :theme, required: true do
      string :name, strong: true, required: true
      boolean :private, strong: true
      integer :group_id, strong: true
    end
  end
  def create
    @theme = Theme.new(theme_params.merge creator: current_user)

    if @theme.save
      render :show, status: :created
    else
      render json: @theme.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/themes/1
  validates :update do
    integer :id, required: true
    object :theme, required: true do
      string :name, strong: true
      boolean :private, strong: true
      integer :group_id, strong: true
    end
  end
  def update
    if @theme.update(theme_params)
      render :show, status: :ok
    else
      render json: @theme.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/themes/1
  validates :destroy do
    integer :id, required: true
  end
  def destroy
    @theme.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def theme_params
      permitted_params[:theme]
    end

    def check_editable
      forbidden 'You cannot edit this theme.' unless @theme.editable?(current_user)
    end
end
