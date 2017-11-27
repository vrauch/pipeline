class BrandStartupsController < ApplicationController
  # load_and_authorize_resource :brand
  # load_and_authorize_resource :brand_startup, :through => :brand
  layout 'brand/index'

  before_action :set_brand
  before_action :set_startup, only: [:delete, :destroy]

  def index
    @startups = @brand.pushed_startups
  end

  def new
    @startups = Startup.limit(50).order(created_at: :desc)
    @pushed_startups_ids = @brand.brand_startups.pluck(:startup_id)
  end

  def create
    @brand_startup = @brand.brand_startups.create(brand_startups_params)
    if @brand_startup
      flash.now[:notice] = { title: 'Done',
                             text: 'Startup was successfully pushed to brand.' }

      StartupProfileQuestion.send_request(
          user: current_user,
          brand: @brand,
          startup: @brand_startup.startup,
          link: new_startup_brand_brief_url(brand_alias: @brand.alias))

      BrandStartupService.new(@brand, @brand_startup.startup).pushing_startup_activity(current_user)
    end
  end

  def destroy
    @startup = Startup.find_by(id: params[:id])
    tags = @startup.tags.where(user_id: @brand.users.pluck(:id))

    if @startup.tags.delete(tags) && @brand.startups.delete(@startup)
      tags.each { |t| t.destroy if t.startup_tags.length == 0 }
      flash.now[:notice] = { title: 'Done',
                             text: 'Startup was removed from brand’s database.' }

      BrandStartupService.new(@brand, @startup).deleting_startup_activity(current_user)
    end
  end

  private

  def brand_startups_params
    params.require(:brand_startup).permit(:startup_id)
  end

  def set_brand
    @brand = Brand.find(params[:brand_id])
  end

  def set_startup
    @startup = Startup.find_by(id: params[:id])
  end
end
