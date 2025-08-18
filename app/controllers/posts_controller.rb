class PostsController < ApplicationController
  before_action :set_service
  before_action :authenticate_user!, only: [:new, :create]

  # GET /posts
  def index
    @posts = @service.get_all_posts
  end

  # GET /posts/:id
  def show
    @post = @service.get_post(params[:id])

    if @post.is_a?(Hash) && @post["error"]
      redirect_to root_path, alert: "Could not fetch post."
    end
  end

  # GET /posts/new
  def new
    # This action is responsible for rendering the new post form.
    @post = Post.new
  end

  # POST /posts
  def create
    response = @service.create_post(title: post_params[:title], body: post_params[:body], user_id: current_user.id)

    if response["error"]
      # Re-initialize @post with submitted params to repopulate the form
      @post = Post.new(post_params)
      flash.now[:alert] = "Could not create post. The external API may be down."
      render :new, status: :unprocessable_entity
    else
      # The JSONPlaceholder API fakes the creation and doesn't actually save the post.
      # Redirecting to the new post's 'show' page would result in a 404 error.
      # We will redirect to the index page instead.
      redirect_to posts_path, notice: "Post was successfully submitted."
    end
  end

  private

  def set_service
    @service = JsonPlaceholderService.new
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
