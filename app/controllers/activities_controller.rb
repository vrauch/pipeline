class ActivitiesController < ApplicationController
  load_and_authorize_resource
  layout 'dashboard'

  def index
    if current_user.evo_team?
      # notes = Note.includes(:assignee, :author, :startup, :comments)
      #              .where('assignee_id IN (:ids) OR author_id IN (:ids) ', ids: User.evo_users.pluck(:id))
      requests = Request.includes(:answer, :author, :startup).all
      updates = UserActivity.updates
      activity = UserActivity.evo_activities.where.not(id: updates.ids).includes(:user)
      collection = requests + updates + activity
    else
      notes = Note.includes(:assignee, :author, :startup, :comments)
                   .where(author_id: current_user.brand_user_ids)
      activity = UserActivity.includes(:user).brand_activities(current_user)
      collection = notes + activity
    end

    sorted_activity = collection.sort_by(&:created_at).reverse
    @all_activity = Kaminari.paginate_array(sorted_activity).page(params[:page])

  end

  def my_tasks
    @my_tasks = Note.includes(:assignee, :author, :startup, :comments)
                    .where(assignee_id: current_user.id).page(params[:page])
                    .order(created_at: :desc)
  end

  def assigned_tasks
    @assigned_tasks = Note.includes(:assignee, :author, :startup, :comments)
                          .where(author_id: current_user.id).tasks.page(params[:page])
                          .order(created_at: :desc)
  end

  def requests
    @requests = Request.includes(:answer, :author, :startup)
                       .page(params[:page])
                       .order(created_at: :desc)
  end

  def updates
    @updates = UserActivity.updates.page(params[:page]).order(created_at: :desc)
  end

end
