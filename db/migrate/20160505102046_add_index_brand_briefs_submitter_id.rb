class AddIndexBrandBriefsSubmitterId < ActiveRecord::Migration
  def change
    add_index :brand_briefs, :submitter_id
  end
end
