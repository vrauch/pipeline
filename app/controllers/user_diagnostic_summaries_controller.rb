class UserDiagnosticSummariesController < ApplicationController
  include UserDiagnosticSummariesHelper
  before_action :check_invite_token, only: [:new, :create]
  before_action :token_present, only: [:new, :create]
  before_action :active_user, only: [:new, :create]
  before_action :user_brand_team

  def new
    @diagnostic_questions = DiagnosticQuestion.preload(:answers).all

    @user_diagnostic_summary = UserDiagnosticSummary.new
  end

  def create
    @diagnostic_types = DiagnosticType.all

    if @user.diagnostic_summaries.create(diagnostic_summary_params.values)
      @user.insight_summaries.create(insight_summaries(diagnostic_summary_params.values))
      @act = @user.insight_summaries.insight_alias('act')
      @brief = @user.brand.brand_brief
      if @brief
        @user.update_attribute(:active, 1)
        sign_in(:user, @user)
      end
    end
  end

  private

    def diagnostic_summary_params
      params.require(:user_diagnostic_summary)
    end

    def token_present
      redirect_to root_url unless @invite
    end

    def user_brand_team
      if @user && (!@user.brand_team? || @user.diagnostic_summaries.any?)
        redirect_to new_user_registration_path(invite_token: @invite.token)
      end
    end

end
