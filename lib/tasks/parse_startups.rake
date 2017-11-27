require 'rake'
require 'csv'
require 'awesome_print'
require 'date'

desc "parse startups"
task :parse_startups => :environment do


  csv_text = File.read(Rails.root.join('lib', 'tasks', 'export_2016-04-28.csv'))
  csv = CSV.parse(csv_text, :headers => true)

  csv.each_with_index do |row, i|
    title = row.to_hash['Startup Name'] == '-' ? nil : row.to_hash['Startup Name']
    location = row.to_hash['Location'] == '-' ? nil : row.to_hash['Location']
    twitter = row.to_hash['Twitter'] == '-' ? nil : row.to_hash['Twitter']
    website = row.to_hash['Website'] == '-' ? nil : row.to_hash['Website']
    contact_email = row.to_hash['Contact Email'] == '-'  ? nil : row.to_hash['Contact Email']
    contact_name = row.to_hash['Contact Name'] == '-'  ? nil : row.to_hash['Contact Name']
    video_url = row.to_hash['Video Url'] == '-'  ? nil : row.to_hash['Video Url']
    date_founded = row.to_hash['Date Founded'] == '-'  ? nil : Date.parse(row.to_hash['Date Founded']).strftime("%F")
    elevator_pitch = row.to_hash['Elevator Pitch'] == '-'  ? nil : row.to_hash['Elevator Pitch']
    date = row.to_hash['Date Profile Created'] == '-'  ? nil : row.to_hash['Date Profile Created']
    technology_life_stage = row.to_hash['Technology Life Stage'] == '-'  ? nil : row.to_hash['Technology Life Stage']
    funding_life_stage = row.to_hash['Funding Life Stage'] == '-'  ? nil : row.to_hash['Funding Life Stage']
    accelerator_program = row.to_hash['Accelerator Program'] == '-'  ? nil : row.to_hash['Accelerator Program']
    founder_name = row.to_hash['Founder Name'] == '-'  ? nil : row.to_hash['Founder Name']
    verticals = row.to_hash['Verticals'] == '-'  ? nil : row.to_hash['Verticals']
    cats = row.to_hash['Categories'] == '-'  ? nil : row.to_hash['Categories']
    target_audience = row.to_hash['Target Audience'] == '-'  ? nil : row.to_hash['Target Audience']
    source = row.to_hash['Source'] == '-'  ? nil : row.to_hash['Source']
    frame_of_reference = row.to_hash['Frame Of Reference'] == '-'  ? nil : row.to_hash['Frame Of Reference']
    roadmap = row.to_hash['Road Map'] == '-'  ? nil : row.to_hash['Road Map']
    datails = row.to_hash['More Details About Road Map'] == '-'  ? nil : row.to_hash['More Details About Road Map']
    brand_collaboration = row.to_hash['Your startup is willing to'] == '-'  ? nil : row.to_hash['Your startup is willing to']
    competitive_differentiation = row.to_hash['Who are your competitors?'] == '-'  ? '' : row.to_hash['Who are your competitors?']
    different = row.to_hash['What makes your different?'] == '-'  ? '' : row.to_hash['What makes your different?']
    brand_experience = row.to_hash['What brands, if any, have you worked with to date?'] == '-'  ? nil : row.to_hash['What brands, if any, have you worked with to date?']
    brand_soulmates = row.to_hash['Who are your brand soulmates?'] == '-'  ? nil : row.to_hash['Who are your brand soulmates?']
    referral_information = row.to_hash['How did you hear about us'] == '-'  ? nil : row.to_hash['How did you hear about us']
    outsearch_status = row.to_hash['Evolution Outreach Status'] == '-'  ? nil : row.to_hash['Evolution Outreach Status']
    watchers = row.to_hash['Evolution Contact'] == '-'  ? nil : row.to_hash['Evolution Contact']
    registration_type = row.to_hash['Registration Type'] == '-'  ? nil : row.to_hash['Registration Type']
    share_info = row.to_hash['Evol8tion is always working hard to put startups like you in front of brands! By keeping this box checked, you are giving us permission to share the information in this profile directly with our brand clients'] == '-'  ? nil : row.to_hash['Evol8tion is always working hard to put startups like you in front of brands! By keeping this box checked, you are giving us permission to share the information in this profile directly with our brand clients']
    receive_emails = row.to_hash['I would like to receive emails about Evol8tion’s events, partnerships or news'] == '-'  ? nil : row.to_hash['I would like to receive emails about Evol8tion’s events, partnerships or news']
    external_id = row.to_hash['Id #'] == '-'  ? nil : row.to_hash['Id #']
    tags = row.to_hash['Tags'] == '-'  ? nil : row.to_hash['Tags']

    user = User.find_by(external_id: external_id)
    startup_attributes = {
      title: title ? title.slice(0..250) : title,
      frame_of_reference: frame_of_reference ? frame_of_reference.slice(0..250) : frame_of_reference,
      location: location ? location.slice(0..250) : location,
      twitter: twitter,
      website: website,
      contact_email: contact_email,
      contact_name: contact_name,
      video_url: video_url,
      date_founded: date_founded ? date_founded : Time.now.strftime("%F"),
      elevator_pitch: elevator_pitch ? elevator_pitch.slice(0..250) : elevator_pitch,
      source: source ? source.slice(0..250) : source,
      outsearch_status: outsearch_status ? outsearch_status.slice(0..250) : outsearch_status,
      creator_id: 1,
      owner_id: (user ? user.id : nil),
      share_info: share_info == 'Yes' ? 1 : 0,
      receive_emails: receive_emails == 'Yes' ? 1 : 0,
      created_at: date,
      updated_at: date
    }
    
    startup = Startup.new(startup_attributes)
    if startup.save(validate: false)
      p startup.id
      ap startup.title
      if technology_life_stage 
        p 'technology_life_stage'
        category = CategoryValue.find_by(content: technology_life_stage)
        if category
          answer = StartupBriefAnswer.where(brief_question_id: 2, category_value_id: category.id).first
          if answer
            bs = startup.startup_brief_summaries.new(question_id: 2, answer_id: answer.id)
            if bs.save
              p category.content
            else
              bs.errors.full_messages
            end
          end
        end
        
      end
      if funding_life_stage
        p 'funding_life_stage'
        category = CategoryValue.find_by(content: funding_life_stage)
        if category
          answer = StartupBriefAnswer.where(brief_question_id: 3, category_value_id: category.id).first
          if answer
            bs = startup.startup_brief_summaries.new(question_id: 3, answer_id: answer.id)
            if bs.save
              p category.content
            else
              bs.errors.full_messages
            end
          end
        end
      end
      if accelerator_program
        p 'accelerator_program'
        category = CategoryValue.find_by(content: accelerator_program)
        if category
          answer = StartupBriefAnswer.where(brief_question_id: 1, category_value_id: category.id).first
          if answer
            bs = startup.startup_brief_summaries.new(question_id: 1, answer_id: answer.id)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
        
      end
      if founder_name
        names = founder_name.gsub(/&| and /i, ",").split(",").map(&:strip).reject(&:empty?)
        p 'founder_name'
        names.each do |name|
          f = startup.founders.new(name: name)
          if f.save
            ap name
          else
            f.errors.full_messages
          end
        end
        
      end
      if verticals
        p 'verticals'
        content = verticals.split(",").map(&:strip).reject(&:empty?)
        categories = CategoryValue.where(content: content)
        categories.each do |category|
          answers = StartupBriefAnswer.where(brief_question_id: 6, category_value_id: category.id)
          answers.each do |answer|
            bs = startup.startup_brief_summaries.new(question_id: 6, answer_id: answer.id)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
      end
      if cats
        p 'categories'
        content = cats.split(",").map(&:strip).reject(&:empty?)
        categories = CategoryValue.where(content: content)
        categories.each do |category|
          answers = StartupBriefAnswer.where(brief_question_id: 5, category_value_id: category.id)
          answers.each do |answer|
            bs = startup.startup_brief_summaries.new(question_id: 5, answer_id: answer.id)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
      end
      if target_audience
        p 'target_audience'
        content = target_audience.split(",").map(&:strip).reject(&:empty?)
        categories = CategoryValue.where(content: content)
        categories.each do |category|
          answers = StartupBriefAnswer.where(brief_question_id: 7, category_value_id: category.id)
          answers.each do |answer|
            bs = startup.startup_brief_summaries.new(question_id: 7, answer_id: answer.id)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
      end
      if roadmap 
        p 'roadmap'
        content = roadmap.split(",").map(&:strip).reject(&:empty?)
        categories = CategoryValue.where(content: content)
        categories.each do |category|
          answers = StartupBriefAnswer.where(brief_question_id: 12, category_value_id: category.id)
          answers.each do |answer|
            bs = startup.startup_brief_summaries.new(question_id: 12, answer_id: answer.id, detail_text: datails)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
      end
      if brand_collaboration
        p 'brand_collaboration'
        content = brand_collaboration.split(",").map(&:strip).reject(&:empty?)
        categories = CategoryValue.where(content: content)
        categories.each do |category|
          answers = StartupBriefAnswer.where(brief_question_id: 16, category_value_id: category.id)
          answers.each do |answer|
            bs = startup.startup_brief_summaries.new(question_id: 16, answer_id: answer.id)
            if bs.save
              ap category.content
            else
              bs.errors.full_messages
            end
          end
        end
        
      end
      if !competitive_differentiation.empty? || !different.empty?
        p 'competitive_differentiation'
        answer = [competitive_differentiation, different].join('\r\n')
        a = startup.startup_brief_summaries.new(question_id: 11, answer_text: answer)
        if a.save
          ap answer
        else
          a.errors.full_messages
        end
      end
      if brand_experience
        p 'brand_experience'
        a = startup.startup_brief_summaries.new(question_id: 14, answer_text: brand_experience)
        if a.save
          ap answer
        else
          a.errors.full_messages
        end
      end
      if brand_soulmates
        p 'brand_soulmates'
        a = startup.startup_brief_summaries.new(question_id: 15, answer_text: brand_soulmates)
        if a.save
          ap answer
        else
          a.errors.full_messages
        end
      end
      if watchers
        p 'watchers'
        users = User.where(external_id: watchers.split(',').map(&:strip))
        users.each do |user|
          u = startup.startup_watchers.new(watcher_id: user.id)
          if u.save
            ap answer
          else
            u.errors.full_messages
          end
        end
      end
      if tags
        p 'tags'
        tags = tags.split(",").map(&:strip).reject(&:empty?)
        tags.each do |tag|
          ap tag
          if tag
            t = Tag.find_or_create_by(title: tag)
            startup.startup_tags.create!(tag_id: t.id, user_id: 1)
          end
        end
      end
    else
      p startup.errors.full_messages
    end
    # ap startup
  end

end