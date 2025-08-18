class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy ]
  # Show all products
  def index
    @page = params.fetch(:page, 1).to_i
    per_page = 5

    # Start with a base query that can be built upon
    query = Product.order(:name)

    # If a search term is present, add a 'where' clause to the query
    if params[:search].present?
      query = query.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Get the total count *after* filtering to ensure pagination is correct
    @total_products = query.count
    # Paginate the final, potentially filtered, query
    @products = query.offset((@page - 1) * per_page).limit(per_page)
    @total_pages = (@total_products / per_page.to_f).ceil
  end

  # Show one product
  def show
    # before action calls set_product
  end

  # Initialize the form for add a new product
  def new
    @product = Product.new
  end

  # Create a new product with the data in the form
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Put the data in the form for editing
  def edit
    # before action calls set_product
  end

  # Update the product with the new data
  def update
    # before action calls set_product
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Destroy the product
  def destroy
    # before action calls set_product
    @product.destroy
    redirect_to products_path, notice: "Product was successfully destroyed."
  end

  # Take the data in the form to create a new product or to edit a existing one
  private
    def set_product
      @product = Product.find_by!(slug: params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
