# Packeges controller class
class PackagesController < ApplicationController
  before_action :package, only: [:edit, :update, :delete, :destroy]

  def index
    @packages = Package.all
  end

  def new
    @package = Package.new
  end

  def edit
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      flash.now[:notice] = { title: 'Done', text: 'Package was successfully created.' }
    else
      flash.now[:error] = { title: 'Error', text: 'Package create error.' }
    end
  end

  def update
    @package.update_attributes(package_params)
    if @package.errors.empty?
      flash.now[:notice] = { title: 'Done', text: 'Package was successfully updated.' }
    else
      flash.now[:error] = { title: 'Error', text: 'Package update error.' }
    end
  end

  def delete

  end

  def destroy
    if @package.nil? || @package.brands.any?
      flash.now[:error] = { title: 'Error', text: 'Package couldn\'t be destroyed it has related brands' }
    else
      @package.destroy
      flash.now[:notice] = { title: 'Done', text: 'Package was successfully deleted.' }
    end
  end

  private

  def package_params
    params.require(:package).permit(
      :name,
      :number_brand_briefs,
      :number_external_pages,
      :number_users,
      :unlimited_users,
      :number_questions,
      :number_startups,
      :number_scorecards,
      :number_scorecard_requests)
  end

  def package
    @package = Package.find_by(id: params[:id])
  end
end
