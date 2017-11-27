class BrandsController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  layout :set_layout
  before_action :set_brand, only: [:show, :edit, :update, :brand_team, :modify,
                                   :brief, :startups, :users, :promo_pages,
                                   :settings, :new_push_startup,
                                   :create_push_startup, :update_question,
                                   :delete_question, :delete, :destroy]
  before_action :set_packages, only: [:new, :create, :refresh, :edit, :update, :settings]
  after_action :creating_brand_activity, only: [:create]
  after_action :pushing_startup_activity, only: [:create_push_startup]
  after_action :updating_brand_activity, only: [:update]


  def index
    @brands = Brand.includes(active_package: [:package]).order(sort_column + " " + sort_direction)
  end

  def show
    session[:back_referer] = nil
    urls = [brand_url(@brand),
            brief_brand_url(@brand),
            brand_startups_url(@brand),
            brand_users_url(@brand),
            promo_pages_brand_url(@brand),
            edit_startup_url(@brand),]

    session[:back_referer] = request.referer unless urls.include? request.referer

    @requests = @brand.requests.includes(:answer, :author, :startup).order(created_at: :desc)
    @new_requests = !(@requests.count == @requests.answered.count)
  end

  def new
    session[:brand_params], session[:brand_step] = {}, nil
    session[:invite_params] = {}
    @brand = Brand.new
    @brand.build_email_template
  end

  def create
    session[:brand_params].deep_merge!(brand_params) if params[:brand]
    if session[:brand_step] == 'questions'
      attr_key = 'brand_questions_attributes'
      if params[:brand]
        session[:brand_params][attr_key] = brand_params[attr_key] ?
                                           brand_params[attr_key] : {}
      else
        session[:brand_params].delete(attr_key)
      end
    end
    params.permit!
    @brand = Brand.new(session[:brand_params])
    @brand.build_email_template(session[:brand_params]['email_template_attributes']
                                    .merge(current_step: session[:brand_step]))

    @brand.current_step = session[:brand_step]
    if params[:back_button] || @brand.valid?
      if params[:back_button]
        @brand.previous_step
      elsif @brand.last_step?
        flash.now[:notice] = { title: 'The brand was successfully added',
                               text: 'Their admin user will receive an 
                                      email invite to their Pipeline' }
        @brand.brand_packages.build(package_id: @brand.package_id,  active: 1)
        @brand.creator_id = current_user.id
        @invite = @brand.invites.build(user_name: @brand.invite_user_name, email: @brand.invite_email,
                                       role: :brand_super)
        @brand.save
      else
        @brand.next_step
      end
    end

    session[:brand_step] = @brand.current_step
  end

  def refresh
    @brand = Brand.new(brand_params)
    @brand.current_step = session[:brand_step]
  end

  def refresh_persisted
    @brand = Brand.find_by(id: params[:id])
    @brand.update_attributes(brand_params)
    @brand.current_step = session[:brand_step]
  end

  def create_question
    if params[:brand][:brand_questions_attributes]
      session[:brand_params]['brand_questions_attributes'] = params[:brand][:brand_questions_attributes]
    end

    params.permit!
    @brand = Brand.new(session[:brand_params])

    @brand.validate

    @brand.current_step = session[:brand_step] = 'questions'
  end

  def update_question
    manage_question
  end

  def delete_question
    manage_question
  end

  def manage_question
    if params[:brand][:brand_questions_attributes]
      session[:brand_params]['brand_questions_attributes'] = params[:brand][:brand_questions_attributes]
    end

    @brand.update_attributes(session[:brand_params])
    @brand.current_step = session[:brand_step] = 'questions'
  end

  def edit
    session[:brand_params], session[:brand_step] = {}, nil
  end

  def update
    session[:brand_params].deep_merge!(brand_params) if params[:brand]
    if ['questions'].include? session[:brand_step]
      attr_key = "brand_#{session[:brand_step]}_attributes"
      if params[:brand]
        session[:brand_params][attr_key] = brand_params[attr_key] ?
            brand_params[attr_key] : {}
      else
        session[:brand_params].delete(attr_key)
      end
    end
    params.permit!
    @brand.current_step = session[:brand_step]
    if @brand.update_attributes(session[:brand_params])
      if params[:back_button]
        @brand.previous_step
      elsif @brand.current_step == 'questions'
        flash.now[:notice] = { title: 'Done.',
                               text: 'Brand was updated successfully' }
        @brand.brand_packages.update_all(active: false)
        @brand.brand_packages.build(package_id: session[:brand_params]['package_id'],  active: 1)
        @brand.save
        @brand.update_columns(updator_id: current_user.id)
        @brand.next_step
      else
        @brand.next_step
      end
    end
    session[:brand_step] = @brand.current_step
  end

  def modify
    @brand_brief_summary = @brand.brand_brief.brief_summaries.first
    @brief_questions = BrandBriefQuestion.preload(:answers,
                                                  answers: [:category_value]).all
    @answers = @brand.form_answers_result
  end

  def brief
    @summary = @brand.form_brief_result
  end

  def users
    @brand_users = @brand.users
  end

  def promo_pages
    @promo_pages = PromoPage.enable_for_review.where(brand_id: @brand.id)
                                              .order(created_at: :desc)
  end

  def search
    @startup = Startup.find_by(id: params[:startup_id])
    @brands = Brand.preload(:package).where('title LIKE ?', "%#{search_params[:query]}%")
    @startup_brands_ids = @startup.brand_startups.pluck(:brand_id)
  end

  def destroy
    if @brand.destroy
      @brand.users.each { |user| user.destroy }
      flash[:notice] = 'Brand has been deleted'
    end
  end

  private

  def sort_column
    Brand.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_type]) ? params[:sort_type] : 'desc'
  end

  def set_layout
    if %w[show brief promo_pages].include?(action_name)
      'brand/index'
    else
      'dashboard'
    end
  end

  def set_brand
    @brand = Brand.find_by(id: params[:brand_id] ? params[:brand_id] : params[:id])
    redirect_to brands_path unless @brand
  end

  def set_packages
    @packages = Package.all
  end

  def search_params
    params.require(:brand).permit(:query)
  end

  def brand_params
    params.require(:brand)
          .permit(:title, :location, :site, :package_id, :creator_id,
                  :invite_email, :invite_user_name, :contact_name,
                  :contact_email, :color, :description, :logo, :logo_cache,
                  email_template_attributes: [:id, :brand_id, :email_color,
                                              :copy_for_email, :email_logo,
                                              :email_logo_cache],
                  brand_questions_attributes: [:id, :brand_id, :question_text,
                                               :answer_type, :first_init,
                                               :question_data_id,
                                               brand_question_answers_attributes: [:id, :brand_id, :answer_text]])
  end

  def creating_brand_activity
    return false if @brand.new_record?
    activity = Activity.find_by(alias: 'brand_created')

    texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{brand_name}}'],
                                   replacements: [current_user.full_name, @brand.title])

    UserActivity.create(user: current_user, activity: activity,
                        resource_id: @brand.id,
                        resource_type: UserActivity.resource_types[:brand],
                        evo_text: texts[:evo])
  end

  def updating_brand_activity
    return false if @brand.errors.any?
    if @brand.previous_changes.any?
      @brand.previous_changes.delete(:updated_at)
      activity = Activity.find_by(alias: 'brand_updated_profile')
      updated = []
      @brand.previous_changes.each do |key, values|
        next if values[0].nil? && values[1] == ''
        updated << "'#{key.humanize.titleize}' from '#{values[0]}' to '#{values[1]}'"
      end

      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{user_name}}', '{{updates}}', '{{brand_name}}'],
                                     replacements: [current_user.full_name, updated.join(';<br>'), @brand.title])

      UserActivity.create(user: current_user, activity: activity,
                          resource_id: @brand.id,
                          resource_type: UserActivity.resource_types[:brand],
                          evo_text: texts[:evo], brand_text: texts[:brand])
    end
  end
end
