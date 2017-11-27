class AnnouncementsController < ApplicationController
  load_and_authorize_resource
  before_action :startup_brand_users, only: [:new, :create]
  before_action :redirect_startup_user, only: [:show]

  def index
    @announcements = Announcement.user_announcement(current_user).page(params[:page])
  end

  def show
    @announcement = Announcement.get_announcement(current_user, params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if params[:type] == 'create'
      if @announcement.save
        flash.now[:notice] = { title: 'Done',
                               text: 'Announcement was successfully sent.' }
      else
        flash.now[:notice] = { title: 'Done',
                               text: 'Announcement send error.'}
      end
      render 'create'
    else
      render 'preview'
    end
  end

  def upload_image
    image = AnnouncementImage.create(image: params[:file])
    if image.save
      render json: { link: image.image.url }
    else
      render json: { error: 'failed to save image' }, status: 500
    end
  end

  private

  def redirect_startup_user
    redirect_to startup_announcements_path(current_user.startup) if current_user.startup?
  end

  def announcement_params
    params.require(:announcement).permit(
        :title,
        :send_to,
        :content,
        :cover,
        :cover_cache,
        receiver_ids: []
    ).merge(creator_id: current_user.id)
  end

  def startup_brand_users
    startups = []
    brands = []
    if params[:announcement] && params[:announcement][:receiver_ids]
      params[:announcement][:receiver_ids].each do |receiver|
        t, id = receiver.split('=')
        if t == '0'
          startups << id.to_i
        else
          brands << id.to_i
        end
      end
    end
    @choices = []
    @choices[0] = []
    @choices[1] = []
    # Startup.where.not(owner_id: nil).each do |startup|
    #   s = {
    #       id: startup.id,
    #       title: startup.title,
    #       logo: startup.logo? ? startup.logo.thumb_small : 's_img.png',
    #       selected: startups.include?(startup.id)
    #   }
    #   @choices[0] << s
    # end
    Brand.all.each do |brand|
      b = {
          id: brand.id,
          title: brand.title,
          logo: brand.logo? ? brand.logo.thumb_small : 'b_img.png',
          selected: brands.include?(brand.id)
      }
      @choices[1] << b
    end
  end


end
