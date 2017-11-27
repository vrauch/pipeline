module BrandsHelper
  BLOCK_SIZE = 223

  def image_style(model)
    width, height = model.logo_dimensions


    if width > height
      per = BLOCK_SIZE.to_f / width.to_f
      h = (height * per).round
      margin = (BLOCK_SIZE - h) / 2
      "width: 100%; height: auto; margin-top: #{margin}px;"
    else
      per = BLOCK_SIZE.to_f / height.to_f
      w = (width * per).round
      margin = (BLOCK_SIZE - w) / 2
      "width: auto; height: 100%; margin-left: #{margin}px;"
    end
  end

  def upload_img_style(dimensions, block_width = BLOCK_SIZE, block_height = BLOCK_SIZE)
    width, height = dimensions


    if width > height
      per = block_width.to_f / width.to_f
      h = (height * per).round
      margin = (block_height - h) / 2
      "width: 100%; height: auto; margin-top: #{margin}px;"
    else
      per = block_height.to_f / height.to_f
      w = (width * per).round
      margin = (block_width - w) / 2
      "width: auto; height: 100%; margin-left: #{margin}px;"
    end
  end

  # def full_size_img_style
  #   'width: 100%;'\
  #   'height: auto;'\
  #   'position: absolute;'\
  #   'top: 1;'\
  #   'right: 1;'\
  #   'bottom: 1;'\
  #   'left: 1;'\
  #   'margin: auto;'\
  # end

  def sortable(column, title = nil, direction)
    title ||= column.titleize
    link_to title, {sort: column, sort_type: direction}, {"data-remote" => "true"}
  end

  def label_status(b)
    if @startup_brands_ids.include?(b.object.id)
      'has_label disabled'
    elsif b.object.brand_startups.size >= b.object.package.number_startups
      'has_label'
    else
      ''
    end
  end
end
