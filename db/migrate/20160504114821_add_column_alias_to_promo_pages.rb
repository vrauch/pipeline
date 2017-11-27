class AddColumnAliasToPromoPages < ActiveRecord::Migration
  def change
    add_column :promo_pages, :alias, :string, after: :updater_id
  end
end
