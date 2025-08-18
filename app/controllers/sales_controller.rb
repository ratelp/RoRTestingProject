class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[ show edit update destroy ]

  # GET /sales 
  def index
    @page = params.fetch(:page, 1).to_i
    per_page = 5

    # Start with a base query that can be built upon
    query = Sale.order(:created_at)

    @total_sales = query.count
    @sales = query.offset((@page - 1) * per_page).limit(per_page)
    @total_pages = (@total_sales / per_page.to_f).ceil
  end

  # GET /sales/1 
  def show
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    @products = Product.order(:name)
  end

  # GET /sales/1/edit
  def edit
    @products = Product.order(:name)
  end

  # POST /sales or 
  def create
    @sale = Sale.new(sale_params)

      if @sale.save
        redirect_to @sale, notice: "Sale was successfully created." 
      else
        @products = Product.order(:name)
        render :new, status: :unprocessable_entity 
      end
  end

  # PATCH/PUT /sales/1 
  def update
      if @sale.update(sale_params)
        redirect_to @sale, notice: "Sale was successfully updated."
      else
        @products = Product.order(:name)
        render :edit, status: :unprocessable_entity 
      end
  end

  # DELETE /sales/1  
  def destroy
    @sale.destroy!
    redirect_to sales_path, status: :see_other, notice: "Sale was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:product_id, :quantity)
    end
end
