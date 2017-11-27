module ApplicationHelper
  def sortable_startup(column, title, direction, type, custom_params = {})
    title ||= column.titleize
    link_to title, {sort: column, sort_type: direction, type: type}.merge(custom_params), {"data-remote" => "true"}
  end

  def sort_column
    Startup.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_type]) ? params[:sort_type] : 'desc'
  end

  def brands_for_select
    Brand.select(:id, :title)
  end
end
