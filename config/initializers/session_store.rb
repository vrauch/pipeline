# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_evol8tion_session'


require 'action_dispatch/middleware/session/dalli_store'
Rails.application.config.session_store :dalli_store, :memcache_server => 'localhost', :namespace => 'sessions', :key => '_evol8tion_session'