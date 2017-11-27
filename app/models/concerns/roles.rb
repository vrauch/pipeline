module Roles
  extend ActiveSupport::Concern

  included do
    # Guest - 0, Startup User - 1, Brand Team User - 2, Brand Team Super User - 3
    # Evo Team User - 4, Evo Team Super User - 5
    enum role: [:guest, :startup, :brand, :brand_super, :evo, :evo_super]
  end

  def evo_team?
    evo? || evo_super?
  end

  def brand_team?
    brand? || brand_super?
  end

  def user_super?
    evo_super? || brand_super?
  end
end