class LogsController < ApplicationController
  before_action :login_required
  before_action :set_log, only: %i[ show edit update destroy ]

  # GET /logs or /logs.json
  def index
    @logs = Log.all
  end

  # GET /logs/1 or /logs/1.json
  def show
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs or /logs.json
  def create
    @book = Book.find(params[:book_id])
    @log = @book.logs.build(log_params)
    @log.micropub_endpoint = session[:micropub_endpoint]
    @log.access_token = session[:access_token]
    @log.user = current_user

    respond_to do |format|
      if @log.save
        format.html { render(partial: 'logs/list', locals: { book: @book }) }
      else
        # XXX
      end
    end
  end

  # PATCH/PUT /logs/1 or /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to log_url(@log), notice: "Log was successfully updated." }
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1 or /logs/1.json
  def destroy
    @log.destroy

    respond_to do |format|
      format.html { redirect_to logs_url, notice: "Log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def log_params
      params.require(:log).permit(:status, :note, :page, :user_id, :book_id)
    end
end
