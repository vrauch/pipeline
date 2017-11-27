class FounderValidator < ActiveModel::Validator
  def validate(record)
    startup = record.startup
    if record.name.blank? && startup.founders.empty?
      record.errors[:name] << "Field required"
    end
  end
end