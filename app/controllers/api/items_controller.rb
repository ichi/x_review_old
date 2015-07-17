class Api::ItemsController < Api::ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)
  before_action :set_item, only: %i(show update destroy)
  before_action :set_theme
  before_action :check_editable, only: %i(create update destroy)

  # GET /api/themes/:theme_id/items
  validates :index do
    integer :theme_id, required: true
  end
  def index
    @items = @theme.items
  end

  # GET /api/items/:id
  validates :show do
    integer :id, required: true
  end
  def show
  end

  # POST /api/themes/:theme_id/items
  validates :create do
    integer :theme_id, required: true
    object :item, required: true do
      string :name, strong: true, required: true
      string :description, strong: true
    end
  end
  def create
    @item = @theme.items.new(item_params)

    if @item.save
      render :show, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/items/:id
  validates :update do
    integer :id, required: true
    object :item, required: true do
      string :name, strong: true
      string :description, strong: true
    end
  end
  def update
    if @item.update(item_params)
      render :show, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/items/:id
  validates :destroy do
    integer :id, required: true
  end
  def destroy
    @item.destroy
    head :no_content
  end

  private

    def set_item
      @item = Item.find(params[:id])
    end

    def set_theme
      @theme = @item ? @item.theme : Theme.find(params[:theme_id])
    end

    def check_editable
      forbidden 'You cannot edit this item.'  unless @theme.editable?(current_user)
    end

    def item_params
      permitted_params[:item]
    end
end
