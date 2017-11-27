desc "Save announcements receivers startups, brands, and team users"
task :save_receivers => :environment do
  mmvs = Announcement.undelivered
  mmvs.each do |mmv|
    mmv.find_receivers
  end
end