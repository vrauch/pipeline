class CreateScorecardTemplatesQuestions < ActiveRecord::Migration
  def change
    create_table :scorecard_templates_questions do |t|
      t.references :scorecard_template, index: true
      t.references :question, index: true

      t.timestamps null: false
    end
  end
end
