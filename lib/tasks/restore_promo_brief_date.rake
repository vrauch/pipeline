require 'rake'

desc "Restore date for startup promo brief"
task :restore_promo_brief_date => :environment do
  StartupPromoBrief.all.each do |startup_promo_brief|
    # brief_summaries = startup_promo_brief.startup.startup_brief_summaries.where(startup_promo_brief_id: startup_promo_brief.id)
    # correct_created_at = brief_summaries.first.created_at if brief_summaries.any?

    brief_summary = StartupBriefSummary.find_by(startup_promo_brief_id: startup_promo_brief.id)
    if brief_summary
      correct_created_at = brief_summary.created_at
      correct_updated_at = brief_summary.updated_at
    end
    correct_created_at = startup_promo_brief.startup.try(:created_at) if correct_created_at.nil?
    correct_updated_at = startup_promo_brief.startup.try(:created_at) if correct_updated_at.nil?
    correct_created_at = correct_created_at || DateTime.now
    correct_updated_at = correct_updated_at || DateTime.now
    puts "WRONG   created_at -> #{startup_promo_brief.created_at}"
    puts "CORRECT created_at -> #{correct_created_at}"
    puts "WRONG   updated_at -> #{startup_promo_brief.updated_at}"
    puts "CORRECT updated_at -> #{correct_updated_at}"
    puts '--------------------------------'
    startup_promo_brief.update(created_at: correct_created_at,
                               updated_at: correct_updated_at)
  end
end
