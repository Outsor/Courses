class NoticesController < ApplicationController
  include SessionsHelper
  before_action :set_notice, only: [:index,:show]
  before_action :admin_logged_in?,only: [:show, :edit, :update, :destroy]
  # GET /notices
  # GET /notices.json
  def index
    @notice = Notice.order(created_at: :desc)
  end

  # GET /notices/1
  # GET /notices/1.json
  def show
    @notice = Notice.find_by_id(params[:id])
  end

  # GET /notices/new
  def new
    @notice = Notice.new
  end



  # POST /notices
  # POST /notices.json
  def create
    @notice = Notice.new(notice_params)

    respond_to do |format|
      if @notice.save
        format.html { redirect_to @notice, notice: '成功创建公告！' }
        format.json { render :show, status: :created, location: @notice }
      else
        format.html { render :new }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:name, :content)
    end
end
