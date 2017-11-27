class RemoveColumnPromoPageIdFromStartups < ActiveRecord::Migration
  def change
    remove_column :startups, :promo_page_id, :integer
  end
end
