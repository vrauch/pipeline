class AddReasonToPromoPages < ActiveRecord::Migration
  def change
    add_column :promo_pages, :reason, :string, limit: 1000, after: :promo_page_status
  end
end
