class PostsController < ApplicationController
  before_action :login_required

  load_resource :book
  load_and_authorize_resource :post, through: :book, shallow: true

  # POST /posts or /posts.json
  def create
    @book = Book.find(params[:book_id])
    @post = @book.posts.build(post_params)
    @post.user = current_user
    @post.micropub_endpoint = session[:micropub_endpoint]
    @post.access_token = session[:access_token]

    respond_to do |format|
      if @post.save
        format.html { render(partial: 'posts/list', locals: { book: @book }) }
      else
        # XXX
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:status, :book_id)
    end
end
