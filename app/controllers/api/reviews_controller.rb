class Api::ReviewsController < Api::ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)
  before_action :set_review, only: %i(show update destroy)
  before_action :set_item_and_theme
  before_action :check_editable, only: %i(create update destroy)

  # GET /api/items/:item_id/reviews
  validates :index do
    integer :item_id, required: true
  end
  def index
    @reviews = @item.reviews
  end

  # GET /api/reviews/:id
  validates :show do
    integer :id, required: true
  end
  def show
  end

  # POST /api/items/:item_id/reviews
  validates :create do
    integer :item_id, required: true
    object :review, required: true do
      integer :score, strong: true, required: true
      string :text, strong: true
    end
  end
  def create
    @review = @item.reviews.new(review_params)

    if @review.save
      render :show, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/reviews/:id
  validates :update do
    integer :id, required: true
    object :review, required: true do
      integer :score, strong: true
      string :text, strong: true
    end
  end
  def update
    if @review.update(review_params)
      render :show, status: :ok
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/reviews/:id
  validates :destroy do
    integer :id, required: true
  end
  def destroy
    @review.destroy
    head :no_content
  end

  private

    def set_review
      @review = Review.find(params[:id])
    end

    def set_item_and_theme
      @item = @review ? @review.item : Item.find(params[:item_id])
      @theme = @item.theme
    end

    def check_editable
      forbidden 'You cannot edit this review.' unless @theme.editable?(current_user)
    end

    def review_params
      permitted_params[:review]
    end
end
