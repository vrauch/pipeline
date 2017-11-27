module Export
  class Xls

    def self.create_startups_xls(startups, current_user)
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet name: 'Startups'
      # sheet.row(0).push '', 'All startups:'

      # Set height rows
      rows = (0..100).to_a
      rows.each{|r| sheet.row(r).height = 15 }

      # Index first and last column table
      start_column = 0
      end_column = 6

      # Index table header
      header_row = 1

      # Generate columns title table
      columns = (start_column..end_column).to_a
      sheet.row(header_row).height = 15

      #Set width columns table
      sheet.column(0).width = 20  # Name
      sheet.column(1).width = 40  # Description
      sheet.column(2).width = 30  # Web-site
      sheet.column(3).width = 20  # Location
      sheet.column(4).width = 20  # Date added
      sheet.column(5).width = 12  # Type
      sheet.column(6).width = 25  # Contact person
      sheet.column(7).width = 25  # Contact email
      sheet.column(8).width = 20  # Tags
      sheet.column(9).width = 30  # Founders
      sheet.column(10).width = 30  # Verticals
      sheet.column(11).width = 30  # Tech Sectors
      sheet.column(12).width = 30  # Target Audience
      sheet.column(13).width = 30  # Development Stage
      sheet.column(14).width = 30  # Funding Stage
      sheet.column(15).width = 30  # Total Funding
      sheet.column(16).width = 30  # Accelerator Program
      sheet.column(17).width = 30  # Revenue Model
      sheet.column(18).width = 30  # Market Strategy
      sheet.column(19).width = 30  # Competitive Differenti
      # sheet.column(20).width = 30  # Brand Experience
      # sheet.column(21).width = 30  # Brand Soulmates
      # sheet.column(22).width = 30  # Brand Collaboration
      sheet.column(20).width = 30  # Roadmap
      sheet.column(21).width = 30  # Roadmap Details
      sheet.column(22).width = 30  # Elevator Pitch
      sheet.column(23).width = 30  # Problem Startup Solves

      if current_user.evo_team?
        sheet.column(24).width = 30  # Brand Experience
        sheet.column(25).width = 30  # Brand Soulmates
        sheet.column(26).width = 30  # Brand Collaboration
      end

      # Generate header table and set style columns header
      sheet.row(header_row).push(
        'Name',
        'Description',
        'Website',
        'Location',
        'Date added',
        'Type',
        'Contact person',
        'Contact email',
        'Tags',
        'Founders',
        'Verticals',
        'Tech Sectors',
        'Target Audience',
        'Development Stage',
        'Funding Stage',
        'Total Funding',
        'Accelerator Program',
        'Revenue Model',
        'Market Strategy',
        'Competitive Differentiation',
        # 'Brand Experience',
        # 'Brand Soulmates',
        # 'Brand Collaboration',
        'Roadmap',
        'Roadmap Details',
        'Elevator Pitch',
        'Problem Startup Solves',
      )

      if current_user.evo_team?
        sheet.row(header_row).push(
          'Brand Experience',
          'Brand Soulmates',
          'Brand Collaboration'
        )
      end

      startups.each_with_index do |startup, i|
        l = i + 2
        startup = startup.decorate
        startup = StartupSummaryDecorator.decorate(startup)

        full_type_of_startup = startup.type_of_startup(current_user)

        type_of_startup = if full_type_of_startup
          full_type_of_startup[:value]
        else
          ''
        end

        sheet.row(l).push(
          startup.title,
          startup.description,
          startup.website,
          startup.location,
          startup.created_at.strftime("%m/%d/%Y"),
          type_of_startup,
          startup.owner_full_name,
          startup.owner_email,
          startup.tags.map{|tag| tag.title}.join(", "),
          startup.founders.map(&:name).join(', '),
          startup.verticals.join(', '),
          startup.tech_sectors.join(', '),
          startup.audience.join(', '),
          startup.dev_stages.join(', '),
          startup.fun_stages.join(', '),
          startup.total_funding,
          startup.accelerator_programs.join(', '),
          startup.revenue_model,
          startup.market_strategy,
          startup.competitive_differentiation,
          startup.roadmaps.join(', '),
          startup.roadmap_details.join(', '),
          startup.elevator_pitch,
          startup.problem_startup_solves,
          # startup.brand_experience,
          # startup.brand_soulmates,
          # startup.brand_collaborations.join(', '),
        )
        if current_user.evo_team?
          sheet.row(l).push(
            startup.brand_experience,
            startup.brand_soulmates,
            startup.brand_collaborations.join(', '),
          )
        end
      end

      file_contents = StringIO.new
      book.write file_contents
      file_contents
    end

    # This method is valid, and generate scorecard xml with all attributes

    # def self.create_xls_from_scorecard_template(scorecard_template)
    #   book = Spreadsheet::Workbook.new
    #   sheet = book.create_worksheet name: "#{scorecard_template.title} scorecards"
    #   sheet.row(0).push "Scorecards from #{scorecard_template.title}:"
    #   sheet.row(0).height = 25
    #   title_format = Spreadsheet::Format.new(weight: :bold, size: 14)
    #   sheet.row(0).set_format(0, title_format)
    #
    #   # Index first and last column table
    #   start_column = 0
    #   end_column = 18
    #
    #   # Index table header
    #   header_row = 1
    #
    #   # Generate columns title table
    #   columns = (start_column..end_column).to_a
    #   sheet.row(header_row).height = 15
    #
    #   #Set width columns table
    #   sheet.column(0).width = 30  # title
    #   sheet.column(1).width = 30  # website
    #   sheet.column(2).width = 30  # dev_stage
    #   sheet.column(3).width = 40  # fun_stag
    #   sheet.column(4).width = 20  # macro_trends
    #   sheet.column(5).width = 20  # micro_trend
    #   sheet.column(6).width = 25  # brand_experience
    #   sheet.column(7).width = 35  # description
    #   sheet.column(8).width = 20  # problem_startup_solve
    #   sheet.column(9).width = 30  # how_it_works
    #   sheet.column(10).width = 30  # state
    #   sheet.column(11).width = 30  # date_founded
    #   sheet.column(12).width = 30  # location
    #   sheet.column(13).width = 50  # recommendation
    #   sheet.column(14).width = 30  # recommendation title
    #   sheet.column(15).width = 20  # product_total_score
    #   sheet.column(16).width = 20  # collaboration_total_score
    #   sheet.column(17).width = 20  # business_total_score
    #
    #   # Generate header table and set style columns header
    #   bold = Spreadsheet::Format.new(weight: :bold)
    #   columns.each{ |c| sheet.row(header_row).set_format(c, bold) }
    #
    #   sheet.row(header_row).push(
    #     'Title',
    #     'Website',
    #     'Development stage',
    #     'Funding stage',
    #     scorecard_template.micro_categories_title,
    #     scorecard_template.macro_categories_title,
    #     'Brand experience',
    #     'Description',
    #     'Problem startup solves',
    #     'How it works',
    #     'State',
    #     'Date founded',
    #     'Location',
    #     'Recommendation title',
    #     'Recommendation',
    #     'Product quality',
    #     'Corporate collaboration',
    #     'Business alignment'
    #   )
    #
    #   scorecard_template.scorecards.each_with_index do |scorecard, i|
    #     l = i + 2
    #     # Set height rows
    #     sheet.row(l).height = 15
    #
    #     scorecard = scorecard.decorate
    #
    #     sheet.row(l).push(
    #       scorecard.title,
    #       scorecard.website,
    #       scorecard.dev_stage,
    #       scorecard.fun_stage,
    #       scorecard.macro_trends,
    #       scorecard.micro_trends,
    #       scorecard.brand_experience,
    #       scorecard.description,
    #       scorecard.problem_startup_solves,
    #       scorecard.how_it_works,
    #       scorecard.state,
    #       scorecard.date_founded.try(:strftime, "%m/%d/%Y"),
    #       scorecard.location,
    #       scorecard.recommendation_title,
    #       scorecard.recommendation,
    #       scorecard.product_total_score,
    #       scorecard.collaboration_total_score,
    #       scorecard.business_total_score,
    #     )
    #   end
    #
    #   file_contents = StringIO.new
    #   book.write file_contents
    #   file_contents
    # end

    def self.generate_xls_from_scorecard_template(scorecard_template)
      product_questions = Question.default
        .from_product(scorecard_template.startup_model)
      collaboration_questions = Question.default
        .from_collaboration(scorecard_template.startup_model)
      business_questions = scorecard_template.questions

      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet name: "#{scorecard_template.title} scorecards"
      sheet.row(0).push "#{scorecard_template.title} Startup Scorecards"
      sheet.row(0).height = 25
      title_format = Spreadsheet::Format.new(weight: :bold, size: 14)
      bold = Spreadsheet::Format.new(weight: :bold)
      main_format = Spreadsheet::Format.new(weight: :bold, horizontal_align: :center)
      text_center = Spreadsheet::Format.new(horizontal_align: :center)

      sheet.row(0).set_format(0, title_format)

      # Index first and last column table
      start_column = 0
      end_column = 22

      # Index table header
      header_row = 1

      # Generate columns title table
      columns = (start_column..end_column).to_a
      sheet.row(header_row).height = 30

      #Set width columns table
      sheet.column(0).width = 30  # Startups
      sheet.column(1).width = 15
      sheet.column(2).width = 20
      sheet.column(3).width = 20
      sheet.column(4).width = 20
      sheet.column(5).width = 20
      sheet.column(6).width = 20
      sheet.column(7).width = 15
      sheet.column(8).width = 20
      sheet.column(9).width = 20
      sheet.column(10).width = 20
      sheet.column(11).width = 20
      sheet.column(12).width = 20
      sheet.column(13).width = 15
      sheet.column(14).width = 20
      sheet.column(15).width = 20
      sheet.column(16).width = 20
      sheet.column(17).width = 20
      sheet.column(18).width = 20
      sheet.column(19).width = 25
      sheet.column(20).width = 25
      sheet.column(21).width = 50

      # Generate header table and set style columns header
      head_fromat = Spreadsheet::Format.new(weight: :bold, vertical_align: :middle, horizontal_align: :center)
      columns.each{ |c| sheet.row(header_row).set_format(c, head_fromat) }

      sheet.row(header_row).push('Startups')

      sheet.row(header_row).push('P Score')
      product_questions.each do |q|
        sheet.row(header_row).push(q.title || q.body)
      end

      sheet.row(header_row).push('C Score')
      collaboration_questions.each do |q|
        sheet.row(header_row).push(q.title || q.body)
      end

      sheet.row(header_row).push('B Score')
      business_questions.each do |q|
        sheet.row(header_row).push(q.title || q.body)
      end
      sheet.row(header_row).push('PC Score')
      sheet.row(header_row).push('B Score')
      sheet.row(header_row).push('RECO')


      scorecard_template.scorecards.each_with_index do |scorecard, i|
        l = i + 2
        # Set height rows
        sheet.row(l).height = 15

        (2..20).to_a.each{ |c| sheet.row(l).set_format(c, text_center) }
        sheet.row(l).set_format(0, bold)
        sheet.row(l).set_format(1, main_format)
        sheet.row(l).set_format(7, main_format)
        sheet.row(l).set_format(13, main_format)

        scorecard = scorecard.decorate

        p_ids = product_questions.pluck(:id)
        p_variants = scorecard.variants
          .product_from(scorecard_template.startup_model)
          .order_by_question_ids(p_ids)

        c_ids = collaboration_questions.pluck(:id)
        c_variants = scorecard.variants
          .collaboration_from(scorecard_template.startup_model)
          .order_by_question_ids(c_ids)

        b_ids = business_questions.pluck(:id)
        b_variants = scorecard.variants
          .business_from(scorecard_template.startup_model)
          .order_by_question_ids(b_ids)

        sheet.row(l).push(
          scorecard.title,
          scorecard.p_score,
          p_variants[0].try(:score),
          p_variants[1].try(:score),
          p_variants[2].try(:score),
          p_variants[3].try(:score),
          p_variants[4].try(:score),
          scorecard.c_score,
          c_variants[0].try(:score),
          c_variants[1].try(:score),
          c_variants[2].try(:score),
          c_variants[3].try(:score),
          c_variants[4].try(:score),
          scorecard.b_score,
          b_variants[0].try(:score),
          b_variants[1].try(:score),
          b_variants[2].try(:score),
          b_variants[3].try(:score),
          b_variants[4].try(:score),
          scorecard.pc_score,
          scorecard.b_score,
          scorecard.recommendation_title.try(:upcase)
        )
      end

      file_contents = StringIO.new
      book.write file_contents
      file_contents
    end
  end
end
