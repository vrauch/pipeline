class StartupSummaryDecorator < Draper::Decorator
  delegate_all

  def initialize(startup, *params)
    super
    @summary = startup.form_brief_results
  end

  def verticals
    summary && summary[:verticals] ? summary[:verticals].map{ |v| v[:content] } : []
  end

  def tech_sectors
    summary && summary[:tech_sectors] ? summary[:tech_sectors].map{ |ts| ts[:content] } : []
  end

  def audience
    if summary && summary[:target_audience].try(:present?)
      summary[:target_audience].try(:map) do |a|
        a[:content]
      end
    else
      []
    end
  end

  def dev_stages
    if summary && summary[:development_stage].try(:present?)
      summary[:development_stage].try(:map) do |stage|
        stage[:content]
      end
    else
      []
    end
  end

  def fun_stages
    if summary && summary[:funding_stage].try(:present?)
      summary[:funding_stage].try(:map) do |stage|
        stage[:content]
      end
    else
      []
    end
  end

  def total_funding
    if summary && summary[:total_funding].try(:present?)
      summary[:total_funding]
    else
      ''
    end
  end

  def accelerator_programs
    if summary && summary[:accelerator_program].try(:present?)
      summary[:accelerator_program].map do |accelerator_program|
        accelerator_program[:content]
      end
    else
      []
    end
  end

  def revenue_model
    if summary && summary[:revenue_model].try(:present?)
      summary[:revenue_model]
    else
      ''
    end
  end

  def market_strategy
    if summary && summary[:market_strategy].try(:present?)
      summary[:market_strategy]
    else
      ''
    end
  end

  def competitive_differentiation
    if summary && summary[:competitive_differentiation].try(:present?)
      summary[:competitive_differentiation]
    else
      ''
    end
  end

  def brand_experience
    if summary && summary[:brand_experience].try(:present?)
      summary[:brand_experience]
    else
      ''
    end
  end

  def brand_soulmates
    if summary && summary[:brand_soulmates].try(:present?)
      summary[:brand_soulmates]
    else
      ''
    end
  end

  def brand_collaborations
    if summary && summary[:brand_collaboration].try(:present?)
      summary[:brand_collaboration].try(:map) do |stage|
        stage[:content]
      end
    else
      []
    end
  end

  def roadmaps
    if summary && summary[:roadmap].try(:present?)
      summary[:roadmap].try(:map) do |roadmap|
        roadmap[:content]
      end
    else
      []
    end
  end

  def roadmap_details
    if summary && summary[:roadmap] && summary[:roadmap].first[:detail].try(:present?)
      summary[:roadmap].map{ |r| r[:detail] }
    else
      []
    end
  end

  def problem_startup_solves
    summary[:problem_startup_solves]
  end

  private

  attr_reader :summary

end
