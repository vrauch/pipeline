class BrandBriefController < ApplicationController
  authorize_resource class: false

  before_action :set_brand, only: [:index, :modify]

  def index
    @summary = @brand.form_brief_result
  end

  def modify
    @brand_brief_summary = @brand.brand_brief.brief_summaries.first
    @brief_questions = BrandBriefQuestion.preload(:answers,
                                                  answers: [:category_value]).all
    @answers = @brand.form_answers_result
  end

  private

  def set_brand
    @brand = current_user.brand
  end
end
