class RequestsController < ApplicationController
  # load_and_authorize_resource

  before_action :find_request, only: [:update, :seen]

  def new
    @request = Request.new
    @startup = Startup.find_by(id: params[:startup_id]) if params[:startup_id]
  end

  def create
    @request = Request.new(create_request_params)
    flash.now[:notice] = { title: 'Done', text: 'Request sent' } if @request.save
    @requests = @request.startup.requests if @request.startup

    if @request.startup_scorecard?
      ActivityService.new(current_user).save_scorecard_request(@request)
    else
      ActivityService.new(current_user).save_request(@request)
    end
  end

  def update
    flash.now[:notice] = { title: 'Done', text: 'Answer sent' } if @request.update(update_request_params)
    @activity = params[:activity]
    ActivityService.new(current_user).save_answer_request(@request)
  end

  def index
    @requests = current_user.brand.requests.includes(:answer, :author)
                                           .order(created_at: :desc)
  end

  def seen
    @request.answer.update_attribute(:new, false)
  end

  private

  def create_request_params
    params.require(:request).permit(:request_type, :body, :startup_id)
                            .merge(author_id: current_user.id,
                                   brand_id: current_user.brand_id)
  end

  def update_request_params
    params.require(:request).permit(:request_type, :body, :startup_id,
                                    answer_attributes: [:body, :author_id])
  end

  def find_request
    @request = Request.find_by(id: params[:id])
  end
end
