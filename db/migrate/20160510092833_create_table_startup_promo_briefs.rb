class CreateTableStartupPromoBriefs < ActiveRecord::Migration
  def change
    create_table :startup_promo_briefs do |t|
      t.references :startup, index: true
      t.references :promo_page, index: true
    end

    Startup.where.not(promo_page_id: nil).each do |startup|
      startup.promo_briefs.create(promo_page_id: startup.promo_page_id)
    end
  end
end
