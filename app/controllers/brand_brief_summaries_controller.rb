class BrandBriefSummariesController < ApplicationController
  before_action :check_invite_token, only: [:new, :create]
  before_action :active_user, only: [:new, :create]
  before_action :user_brand_team, except: [:update]

  def new
    @answers = {}
    @brand_brief_summary = BrandBriefSummary.new

    @brief_questions = BrandBriefQuestion.preload(:answers,
                                                  answers: [:category_value]).all
  end

  def create
    @brand_brief = BrandBrief.new(brand_id: @invite.brand.id, submitter_id: @user.id)

    if params[:brand_brief_summary]
      @brand_brief.save
      @brand_brief_summary = BrandBriefSummary.new(brand_brief: @brand_brief)
      @brand_brief_summary.save_answers(brief_params)
    end
    @user.update_attribute(:active, 1)
    sign_in(:user, @user)
  end

  def update
    @brand_brief_summary = BrandBriefSummary.find_by(id: params[:id])
    @brand = @brand_brief_summary.brand_brief.brand
    @brand_brief_summary.save_answers(brief_params)
    @summary = @brand.form_brief_result
  end

  private

    def brief_params
      params.require(:brand_brief_summary)
    end

    def user_brand_team
      if @user.nil? || !@user.brand_team? || @user.brand.brand_brief
        redirect_to root_path
      end
    end
end
