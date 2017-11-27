module DashboardHelper

  def current_class
    if current_page?(activities_path)
      'clearfix'
    elsif current_page?(dashboard_path)
      'content_index'
    else
      ''
    end
  end

end
