require 'rake'

desc "Change Healthcare icon  in Category Value"
task change_healthcare_icon: :environment do
  category_value = CategoryValue.find_by_content_and_icon_name('Healthcare', 'health')
  p 'Healthcare updated!' if category_value && category_value.update(icon_name: 'healthcare')
end
