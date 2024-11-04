class PostsController < ApplicationController
  http_basic_authenticate_with name: "123", password: "456", except: [:index, :show]
  def index
    @posts = Post.includes(:user, :comments)
                 .order(created_at: :desc)
  
    if params[:username].present?
      @posts = @posts.joins(:user)
                     .where('LOWER(users.username) LIKE ?', "%#{params[:username].downcase}%")
    end
  
    @posts = @posts.all
  end

  def show
    @post = Post.includes(:user, :comments).find_by(id: params[:id])
    
    if @post.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    end
    
    @comment = @post.comments.build
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end
  private
    def post_params
      params.require(:post).permit(:title, :body, :status)
    end
end
