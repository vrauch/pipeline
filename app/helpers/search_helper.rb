module SearchHelper
  def advanced_conditions
    search = {}
    search[:location] = params[:search][:location] unless params[:search][:location].blank?
    search
  end

  def advanced_with
    search = {}
    sp = params[:search]
    if !sp[:added_to].blank?
      unless sp[:added_from].blank?
        search[:date_founded] = sp[:added_from].to_time.to_i..(sp[:added_to].to_time + 1.day).to_i
      else
        search[:date_founded] = Time.new(2000).to_i..(sp[:added_to].to_time + 1.day).to_time.to_i
      end
    elsif !sp[:added_from].blank?
      search[:date_founded] = sp[:added_from].to_time.to_i..Time.now.to_i
    end
    search[:id] = sp[:startups] unless sp[:startups].nil?
    search
  end

  def advanced_with_all
    with_all = {}
    sp = params[:search]
    answer_ids = sp[:category_value_ids].reject(&:blank?) unless sp[:category_value_ids].nil?

    return with_all if answer_ids.blank?
    category_values = CategoryValue.where(id: answer_ids)

    category_values.each do |cv|
      if with_all.has_key?(cv.category_id)
        with_all[cv.category_id] << cv.id
      else
        with_all[cv.category_id] = [cv.id]
      end
    end

    with_all.values
  end
end
