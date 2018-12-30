class HomesController < ApplicationController
  include CourseHelper

  def index
    @notice = Notice.order(created_at: :desc)
    # @notice = Notice.order(created_at: :desc)
    # @notice=Notice.new
    # @notice.name="123"
    # @notice.content="456"
  end
end
