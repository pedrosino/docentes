class PostsController < ApplicationController
  def index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
  end

  def post_params
    params.require(:post).permit(:titulo, :corpo, :data)
  end
end
