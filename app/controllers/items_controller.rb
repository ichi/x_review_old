class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_theme

  # GET /themes/10/items
  def index
    @items = Item.all
  end

  # GET /items/1
  def show
  end

  # GET /themes/10/items/new
  def new
    @item = Item.new(theme: @theme)
  end

  # GET /items/1/edit
  def edit
  end

  # POST /themes/10/items
  def create
    @item = Item.new(item_params.merge theme: @theme)

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to theme_items_url(@theme), notice: 'Item was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_theme
      @theme = @item ? @item.theme : Theme.find(params[:theme_id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:name, :description)
    end
end
