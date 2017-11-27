module ScorecardTemplatesHelper
  def scorecard_template_title(template)
    "#{template.title_brand}-#{template.title_brief}-#{template.title_year}"
  end

  def sc_temp_limit_text(field_name, value)
    max = ScorecardTemplate.max_length_of(field_name.to_sym)
    length = value ? value.length : 0
    "#{max.to_i-length} characters"
  end

  def ps_type_number(type_name)
    ScorecardTemplate::PRODUCT_SECTION_TYPES.index(type_name)
  end

  def ps_type(type_number)
    ScorecardTemplate::PRODUCT_SECTION_TYPES[type_number.to_i]
  end
end
