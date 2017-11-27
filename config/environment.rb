# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if instance_tag.class.name == "ActionView::Helpers::Tags::FileField" &&
    instance_tag.object.class.name == "Startup" ||
    instance_tag.object.class.name == 'ScorecardDecorator'
    html_tag
  else
    "<div class='error_field'>#{html_tag}<span class='error_text'>#{instance_tag.error_message.first}</span></div>".html_safe
  end
end
