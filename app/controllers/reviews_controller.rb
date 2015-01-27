class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_item_and_theme

  # GET /reviews
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new(item: @item)
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  def create
    @review = Review.new(review_params.merge item: @item)

    if @review.save
      redirect_to @review, notice: 'Review was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      redirect_to @review, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    redirect_to item_reviews_url(@item), notice: 'Review was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    def set_item_and_theme
      @item = @review ? @review.item : Item.find(params[:item_id])
      @theme = @item.theme
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:score, :text)
    end
end
