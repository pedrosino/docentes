class PostsController < ApplicationController
  def index
    @posts = Post.all.sort_by(&:created_at).reverse
    @editais = Edital.all.sort_by(&:publicacao).reverse
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
  end

  def show
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:titulo, :corpo, :data)
  end
end
