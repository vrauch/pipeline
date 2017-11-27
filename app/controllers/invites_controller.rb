class InvitesController < ApplicationController
  # load_and_authorize_resource
  before_action :get_tags_count, only: [:create]
  before_action :get_invite, only: [:edit, :update, :delete, :destroy]
  
  def new
    if current_user.evo_team?
      if params[:resource_id]
        role = { role: :brand_super }
      else
        role = { role: :evo_super }
      end
    elsif current_user.brand_super?
      role = { role: :brand_super }
    else
      role = {}
    end

    @invite = Invite.new(role.merge(resource_id: params[:resource_id],
                                    user_group: params[:user_group]))
  end

  def create
    @invite = Invite.create(invite_params)
    if @invite.startup?
      @startup_tags = StartupTag.startup_tags(@invite.startup.id, current_user.team_mate_ids)
      @startup = @invite.startup.decorate
    end
    flash.now[:notice] = { title: 'User has been invited.',
                           text: 'Email with instructions has been sent to user.' }
  end

  def new_startup
    @invite = Invite.new(role: :startup, resource_id: params[:resource_id])
  end

  def edit
    @invite = Invite.find_by(id: params[:id])
  end

  def update
    if @invite.update_attributes(invite_params)
      if @invite.startup?
        @startup_tags = StartupTag.startup_tags(@invite.resource_id, current_user.team_mate_ids)
        @startup = @invite.startup.decorate
      end
      flash.now[:notice] = { title: 'Invite has been resent.',
                             text: 'Email with instructions has been sent to user.' }
    end
  end

  def destroy
    if @invite.destroy
      flash.now[:notice] = { title: 'Done.', text: 'Invite has been deleted.'}
    end
  end

  private

  def get_invite
    @invite = Invite.find_by(id: params[:id])
  end

  def invite_params
    invite_params = params.require(:invite).permit(:email, :user_group, :role,
                                                   :resource_id)
                                           .merge(sent_by: current_user.id)

    return invite_params if invite_params[:role] == 'startup'
    if invite_params[:resource_id]
      unless current_user.user_super?
        if current_user.evo?
          invite_params.merge!(role: :evo) unless invite_params[:user_group] == 'brand_team'
        else
          invite_params.merge!(role: :brand)
        end
      end
    else
      unless current_user.evo_super?
        invite_params.merge!(role: :evo)
      end
    end
    invite_params
  end

  def get_tags_count
    @tag_counts = StartupTag.where(user_id: current_user.evo_team? ? 
                                            User.evo_users.pluck(:id) : 
                                            current_user.brand_user_ids)
                            .group(:startup_id)
                            .count(:id)
  end
end
