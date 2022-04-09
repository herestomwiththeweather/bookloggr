class LogsController < ApplicationController
  before_action :login_required

  load_resource :book
  load_and_authorize_resource :log, through: :book, shallow: true

  # GET /logs/1 or /logs/1.json
  def show
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs or /logs.json
  def create
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
        format.html { render(@log) }
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
    # Only allow a list of trusted parameters through.
    def log_params
      params.require(:log).permit(:status, :note, :page, :book_id)
    end
end
