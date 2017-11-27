module ScorecardsHelper
  def templates_for_select(templates, selected_template_id = nil)
    if templates
      templates_for_select = templates.map do |t|
        [t.title, t.id, { 'data-image'=> t.get_logo.try(:thumb_small) } ]
      end
      options_for_select(templates_for_select, selected_template_id)
    else
      []
    end
  end

  def scorecard_back_link
    if defined?(@back_link) && @back_link && @back_link != ''
      @back_link
    else
      scorecards_path
    end
  end

  def scorecard_label_status(b)
    if @scorecard_brands_ids.include?(b.object.id)
      'has_label disabled'
    else
      ''
    end
  end

  def startups_for_select(startups, selected_startup_id = nil)
    if startups
      startups_for_select = startups.map do |s|
        [s.title, s.id, { 'data-image'=> s.logo.try(:thumb_small) } ]
      end
      options_for_select(startups_for_select, selected_startup_id)
    else
      []
    end
  end

  def info_item(f, item, title = nil, value = nil, data_options = {})
    value ||= f.object.try(item.to_s + '_fv')
    limit = Scorecard.max_length_of(item.to_sym)
    data_attr = { default_val: f.object.try(item.to_sym) }.merge(data_options)
    data_attr[:max_length] = limit if limit > 0
    content_tag(:div, class: 'info_item editable') do
      concat content_tag(:div, title.upcase, class: 'info_item_title') if title && !title.try(:empty?)
      concat(content_tag(:p, class: 'editable_text') do
        concat content_tag(:span, value, class: 'hidden_input_value')
        concat( content_tag(:span, class: 'hidden_input_block') do
          concat(content_tag(:span, sc_limit_text(item.to_sym, f.object.try(item.to_sym), data_options[:small_field] ? 'char' : 'characters'), class: 'limit_text')) if limit > 0
          if block_given?
            yield
          else
            concat(f.text_field(item.to_sym, class: 'hidden_input',
              placeholder: 'Type copy here…',
              data: data_attr))
          end
        end )
      end
      )
      concat( link_to('#', class: 'edit_link') do
        concat(content_tag(:i, nil, class: 'icon icon_edit'))
        concat(content_tag(:span, ' Edit'))
      end )
    end
  end

  def product_total_score(answer_ids = session[:scorecard_answers].try(:values))
    Variant.where(id: answer_ids)
      .product_from(@scorecard.scorecard_template.startup_model)
      .total_score
  end

  def collaboration_total_score(answer_ids = session[:scorecard_answers].try(:values))
    Variant.where(id: answer_ids)
      .collaboration_from(@scorecard.scorecard_template.startup_model)
      .total_score
  end

  def business_total_score(answer_ids = session[:scorecard_answers].try(:values))
    Variant.where(id: answer_ids)
      .business_from(@scorecard.scorecard_template.startup_model)
      .total_score
  end

  # sc - scorecard
  def sc_limit_text(field_name, value, message = 'characters')
    max = Scorecard.max_length_of(field_name.to_sym)
    length = value ? value.length : 0
    "#{max-length} #{message}"
  end

  def startup_model_for_drafts(drafts)
    if drafts.any?
      states = drafts.includes(:scorecard_template)
        .pluck('scorecard_templates.startup_model').uniq
      if states.length > 1
        'ALL'
      else
        ScorecardTemplate.startup_models.key(states[0]).upcase
      end
    else
      'NONE'
    end
  end

  def sc_recommendation_title
    pc_score = product_total_score * 1.5 + collaboration_total_score
    b_score = business_total_score
    scorecard_recommendation_title(pc_score, b_score)
  end

private
  def scorecard_recommendation_title(pc_score, b_score)
    if pc_score.between?(20, 25) && b_score.between?(8, 10)
      'NO BRAINER'
    elsif (pc_score.between?(15, 20) && b_score.between?(5.5, 10)) ||
          (pc_score.between?(20, 25) && b_score.between?(5.5, 7))
      'EXPLORE NOW'
    elsif (pc_score.between?(10, 14.99) && b_score.between?(5.5, 10))
      'TRACK STARTUP DEVELOPMENT PROGRESS'
    elsif (pc_score.between?(15, 25) && b_score.between?(3.5, 5.49))
      'TRACK ROADMAP AND BUSINESS NEEDS'
    else
      'PASS'
    end
  end
end
