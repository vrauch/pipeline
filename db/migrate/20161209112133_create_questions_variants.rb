class CreateQuestionsVariants < ActiveRecord::Migration
  def change
    create_table :questions_variants do |t|
      t.references :question, index: true
      t.references :variant, index: true
    end
  end
end
