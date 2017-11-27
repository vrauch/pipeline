class DashboardController < ApplicationController
  include DateTimeHelper
  authorize_resource class: false

  def index
    @startups_watclist_count = Startup.watchlist(current_user).count

    @founder_total = Startup.preload(:owner).founder(current_user).count

    current_user.brand_team? ? dashboard_brand : dashboard_evo
  end

  def dashboard_brand
    @startups_all_count = Startup.all_startups(current_user).count
    @startups_evolution = Startup.evolution(current_user).page(1).per(4)
                                 .where(brand_startups: { created_at: 1.month.ago..DateTime.now })
                                 .order('brand_startups.created_at DESC')
    @startups_founder = Startup.founder(current_user).page(1).per(4)
                            .where(created_at: 1.month.ago..DateTime.now)
                            .order(created_at: :desc)

    @evolution_total = Startup.evolution(current_user).count

    @brand = current_user.brand
    @m_mv = Announcement.user_announcement(current_user).order(created_at: :desc).limit(4)
    @top_categories = Startup.where(id: Startup.all_startups(current_user).pluck(:id)).top_categories
    @saved_searches = Search.preload(:user).where(user_id: @brand.users.pluck(:id))
    @activities = UserActivity.brand_activities(current_user).order(created_at: :desc)
                                                             .limit(5)
  end

  def dashboard_evo
    @founder_brand_history = Startup.prepare_history(Startup.watchlist(current_user).entry_history, year_months)
    @founder_history = Startup.prepare_history(Startup.founder(current_user).entry_history, year_months)
    @notifications = Note.where(assignee_id: current_user.id).includes(:comments, :author, :startup)
                                                             .order(created_at: :desc)
                                                             .limit(3)
    @activities = UserActivity.evo_activities.includes(:user)
                                             .order(created_at: :desc)
                                             .limit(5)
    @startups_founder_brand = Startup.preload(:owner).founder_brand(current_user)
                                     .where(created_at: 1.month.ago..DateTime.now)
                                     .page(1).per(4).order(created_at: :desc)
    @startups_founder = Startup.founder_evolution(current_user).page(1).per(4)
                            .where(created_at: 1.month.ago..DateTime.now)
                            .order(created_at: :desc)
    @founder_brand_total = Startup.founder_brand(current_user).count
    @evo_generated_total = Startup.evo_generated(current_user).count
    @startups_all_count = @founder_total + @founder_brand_total + @startups_watclist_count + @evo_generated_total
    @total_pipelines = Brand.all.count
    @total_brand_logins = UserActivity.brand_logins
    @new_requests = Request.new_requests.count
    @saved_searches = Search.preload(:user).where(user_id: User.evo_users.pluck(:id))
                            .order(created_at: :desc).limit(6)
    gon.push({
      dates_range:   year_months,
      founder_brand: @founder_brand_history,
      founder:       @founder_history
    })
  end
end
