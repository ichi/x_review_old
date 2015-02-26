class Api::ThemesController < Api::ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  # GET /api/themes
  def index
    @themes = Theme.all
  end

  # GET /api/themes/1
  def show
  end

  # POST /api/themes
  def create
    @theme = Theme.new(theme_params.merge creator: current_user)

    if @theme.save
      render :show, status: :created
    else
      render json: @theme.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/themes/1
  def update
    if @theme.update(theme_params)
      render :show, status: :ok
    else
      render json: @theme.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/themes/1
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
      params.require(:theme).permit(:name, :private, :group_id)
    end
end
