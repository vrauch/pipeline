require 'rake'
require 'csv'
require 'awesome_print'
require 'date'

desc "parse users"
task :parse_users => :environment do


  csv_text = File.read(Rails.root.join('lib', 'tasks', 'export_startup_users.csv'))
  csv = CSV.parse(csv_text, :headers => true)
  cnt = 0
  csv.each_with_index do |row, i|
    id = row.to_hash['id']
    email = row.to_hash['email']
    email = email.split(',')[0]
    full_name = row.to_hash['full_name']
    created_at = row.to_hash['created_at']
    external_id = row.to_hash['external_id']
    
    user = User.new(
      email: email,
      password: email,
      password_confirmation: email,
      role: 1,
      confirmed_at: Time.now,
      full_name: full_name.empty? ? ' ' : full_name,
      created_at: created_at,
      external_id: external_id,
      active: 1,
    )
    if user.save
      cnt += 1
      p user.id
      startup = Startup.find_by(id: id)
      startup.update_attribute(:owner_id, user.id)
      startup.update_attribute(:creator_id, user.id)
    else
      p user.errors
    end
  end
  ap "#{cnt} users was added"
end