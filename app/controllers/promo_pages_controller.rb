class PromoPagesController < ApplicationController
  load_and_authorize_resource

  before_action :set_brand,      only: [:index, :brand_questions, :new, :create,
                                        :refresh, :edit, :update, :reject,
                                        :approve]
  before_action :set_promo_page_by_token, only: [:show]
  before_action :set_promo_page, only: [:edit, :update, :destroy,
                                        :view_questions, :unpublish,
                                        :reject, :approve, :update_question,
                                        :delete_question]
  before_action :set_session, only: [:create, :update]
  after_action :create_request, only: [:create, :update]
  after_action :create_request_answer, only: [:approve, :reject]

  def index
    @promo_pages = PromoPage.where(brand_id: @brand.id).order(created_at: :desc)
  end

  def show
    unless @promo_page.brand
      raise ActionController::RoutingError.new('Not Found')
    end
    current_user.startup.promo_briefs.create(promo_page_id: @promo_page.id) if user_signed_in?
    render layout: 'promo'
  end

  def new
    session[:promo_page_params], session[:promo_page_step] = {}, nil
    @promo_page = PromoPage.new

    if @brand.brand_questions.any?
      dup_brand_questions
    end
  end

  def create
    @promo_page = PromoPage.new(session[:promo_page_params])
    unless @promo_page.promo_page_details.any?
      @promo_page.promo_page_details.build
    end

    @promo_page.current_step = session[:promo_page_step]
    if @promo_page.valid?
      if params[:back_button]
        @promo_page.previous_step
      elsif @promo_page.last_step?
        @promo_pages = []
        if params[:save_as_draft]
          @promo_page.promo_page_status = :inactive
        end
        @promo_page.save
        flash.now[:notice] = { title: 'Done', text: 'Landing page was saved' }
      else
        @promo_page.next_step
      end
    end
    session[:promo_page_step] = @promo_page.current_step
  end

  def refresh
    @promo_page = PromoPage.new(promo_page_params)
    @promo_page.current_step = session[:promo_page_step]
    @promo_page.validate
  end

  def refresh_persisted
    @promo_page = PromoPage.find_by(id: params[:id])
    @promo_page.update_attributes(promo_page_params)
    @promo_page.current_step = session[:promo_page_step]
  end

  def create_question
    if promo_page_params[:promo_page_questions_attributes]
      session[:promo_page_params]['promo_page_questions_attributes'] = promo_page_params[:promo_page_questions_attributes]
    end

    params.permit!
    @promo_page = PromoPage.new(session[:promo_page_params])

    @promo_page.validate

    @promo_page.current_step = session[:promo_page_step] = 'questions'
  end

  def update_question
    manage_question
  end

  def delete_question
    manage_question
  end

  def manage_question
    if promo_page_params[:promo_page_questions_attributes]
      session[:promo_page_params]['promo_page_questions_attributes'] = promo_page_params[:promo_page_questions_attributes]
    end

    @promo_page.update_attributes(session[:promo_page_params])
    @promo_page.current_step = session[:promo_page_step] = 'questions'
  end

  def edit
    session[:promo_page_params], session[:promo_page_step] = {}, nil
  end

  def update
    @promo_page.current_step = session[:promo_page_step]
    if @promo_page.update_attributes(promo_page_params)
      if params[:back_button]
        @promo_page.previous_step
      elsif @promo_page.last_step?
        flash.now[:notice] = { title: 'Promo page was updated',
                               text: 'All users will receive notifications' }
        if params[:save_as_draft]
          @promo_page.promo_page_status = :inactive
        elsif params[:submit]
          @promo_page.promo_page_status = :waiting
        end

        @promo_page.update_attributes(session[:promo_page_params])
      else
        @promo_page.next_step
      end
    end
    session[:promo_page_step] = @promo_page.current_step
  end

  def destroy
    @promo_page.destroy
    flash.now[:notice] = { title: 'Done', text: 'Landing page was successfully deleted' }
  end

  def reject
    params[:reason] = 'No reason given' if params[:reason].blank?
    if params[:reason]
      @promo_page.update_attributes(promo_page_status: PromoPage.promo_page_statuses[:rejected],
                                    reason: params[:reason])
    else
      @promo_page.update_attribute(:promo_page_status, PromoPage.promo_page_statuses[:rejected])
    end
    flash.now[:notice] = { title: 'Done', text: 'Landing page has been rejected' }
    BrandMailer.promo_page_status(@promo_page).deliver_now
  end

  def approve
    @promo_page.update_attribute(:promo_page_status, PromoPage.promo_page_statuses[:published])
    flash.now[:notice] = { title: 'Done', text: 'Landing page has been approved' }
    BrandMailer.promo_page_status(@promo_page).deliver_now
  end

  def unpublish
    @promo_page.update_attribute(:promo_page_status, PromoPage.promo_page_statuses[:inactive])
    flash.now[:notice] = { title: 'Done', text: 'Landing page has been unpublished' }
  end

  private

  def set_promo_page_by_token
    @promo_page = PromoPage.published.find_by(alias: params[:alias])
    redirect_to root_path unless @promo_page
  end

  def set_brand
    @brand = current_user.brand
  end

  def set_promo_page
    @promo_page = PromoPage.find_by(id: params[:id])
  end

  def dup_brand_questions
    q_attr_key = :promo_page_questions_attributes
    a_attr_key = :promo_page_question_answers_attributes
    session[:promo_page_params][q_attr_key] = []
    @brand.brand_questions.each_with_index do |question, index|
      clone_question = { first_init: false,
                         question_data_id: "promo_page_promo_page_questions_attributes_#{index}_question_text",
                         question_text: question.question_text,
                         answer_type: question.answer_type,
                         a_attr_key => [] }
      if question.single? || question.multi?
        question.brand_question_answers.each do |answer|
          clone_question[a_attr_key] << { answer_text: answer.answer_text,
                                          _destroy: false }
        end
      end
      session[:promo_page_params][q_attr_key] << clone_question
    end
  end

  def promo_page_params
    params.require(:promo_page)
          .permit(:cover_image, :cover_image_cache, :name, :intro_message,
                  :brand_color, :inspirational_title, :description, :form_image,
                  :form_image_cache, :form_title, :form_copy, :website, :current_step,
                  :promo_page_status, :reason, :is_draft, :creator_id, :updater_id,
                  promo_page_details_attributes: [:id, :promo_page_id, :inspire_image,
                       :inspire_image_cache, :inspire_video, :inspire_title,
                       :inspire_description],
                  promo_page_questions_attributes:
                       [:id, :promo_page_id, :question_text, :answer_type,
                        :first_init, :question_data_id, :_destroy,
                        promo_page_question_answers_attributes: [:id,
                                                                :promo_page_question_id,
                                                                :answer_text,
                                                                :_destroy]])
          .merge(brand_id: current_user.brand.id, creator_id: current_user.id)
  end

  def set_session
    session[:promo_page_params].deep_merge!(promo_page_params) if params[:promo_page]
    if ['questions', 'details'].include? session[:promo_page_step]
      attrs_key = "promo_page_#{session[:promo_page_step]}_attributes"
      if params[:promo_page]
        session[:promo_page_params][attrs_key] = promo_page_params[attrs_key] ?
                                                 promo_page_params[attrs_key] : {}
      else
        session[:promo_page_params].delete(attrs_key)
      end
    end
    params.permit!
  end

  def create_request
    return false if @promo_page.new_record? || @promo_page.inactive?

    @request = Request.create(request_type: Request.request_types[:promo_page_approve],
                              body: "We created a landing page “#{@promo_page.name}”, please approve it!", author_id: current_user.id,
                              brand_id: (current_user.brand_id || @promo_page.brand_id), promo_page_id: @promo_page.id)

    ActivityService.new(current_user).save_request(@request)
  end

  def create_request_answer
    if @promo_page.published?
      answer_text = 'Your landing page looks great! We approved and published it.'
    else
      answer_text = 'Your landing page looks good. We just need you to make a few changes and then we will go ahead and publish it!'
    end

    if @promo_page.request
      @promo_page.request.create_answer(body: answer_text,
                                        author_id: current_user.id)
      ActivityService.new(current_user).save_answer_request(@promo_page.request)
    else
      @brand = @promo_page.brand
      @request = Request.create(request_type: Request.request_types[:promo_page_approve],
                                body: answer_text, author_id: current_user.id,
                                brand_id: @brand.id, promo_page_id: @promo_page.id)

      ActivityService.new(current_user).save_request(@request)
    end
  end

end
