class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :is_posted_user?, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    if params[:mode] == 'all'
      @posts = Post.joins(:user).eager_load(:user)
      @mode = 'all'
    else
      # ログインしているユーザの記事を取得
      @posts = Post.joins(:user).eager_load(:user).where(user_id: current_user.id)
      @mode = 'user'
    end
    @posts.each do |post|
      # 表示する記事の文章をはじめの40文字にする
      post.content = post.content.slice(1, 40)
    end
  end

  def index_all
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    # ユーザIDを設定
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html {redirect_to @post, notice: '記事を投稿しました。'}
        format.json {render :show, status: :created, location: @post}
      else
        format.html {render :new}
        format.json {render json: @post.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html {redirect_to @post, notice: '記事を更新しました。'}
        format.json {render :show, status: :ok, location: @post}
      else
        format.html {render :edit}
        format.json {render json: @post.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html {redirect_to posts_url, notice: '記事を削除しました。'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:user_id, :title, :content)
  end

  # 不正なエントリ操作はホーム画面にリダイレクト
  def is_posted_user?
    if @post.user_id != current_user.id
      redirect_to :controller => 'home', :action => 'index'
    end
  end
end
