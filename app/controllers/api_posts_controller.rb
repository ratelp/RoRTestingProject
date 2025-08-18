require 'net/http'
require 'uri'
require 'json'


class ApiPostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    # estabelece conexão http
    uri = URI.join(request.base_url, '/api/v1/posts')
    http = Net::HTTP.new(uri.host, uri.port)

    # encrypta para caso de estar no ambiente de produção
    http.use_ssl = true if Rails.env.production?

    # constroi requisição com json
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = { post: post_params}.to_json

    # envia requisição e recebe resposta
    res = http.request(req)

    if res.is_a?(Net::HTTPSuccess)
      redirect_to posts_path, notice: "Post was successfully created via API."
    else
      @post = Post.new(post_params)
      errors = JSON.parse(res.body)["errors"] rescue ["An unknown API error occurred."]
      errors.each { |error| @post.errors.add(:base, error) }
      render :new, status: :unprocessable_entity
    end
  end

  private
  
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
