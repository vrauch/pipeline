class AddColumnPromoPageIdToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :promo_page_id, :integer, after: :new
  end
end
