require 'rake'

desc "Create super user"
task :create_super_user => :environment do
  User.create(full_name: 'Super User',
              email: 'admin@startupsforbrands.com',
              password: 'admin_evol8tion',
              password_confirmation: 'admin_evol8tion',
              role: :evo_super)

end