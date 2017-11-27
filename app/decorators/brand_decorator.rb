class BrandDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def logo_url
    logo? ? h.image_tag(logo.thumb_medium, alt: 'Logo', width: 90) :
        h.content_tag(:span, initial, class: 'brand_img_holder', style: 'width:43px; height:43px;')
  end

end
