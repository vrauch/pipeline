class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    team_user_ids = user.evo_team? ? User.evo_users.pluck(:id) :
                                     user.brand_user_ids

    alias_action :new_push, :create_push, to: :push
    alias_action :mark_as_done, :mark_as_undone, to: :mark_task

    case
      when user.evo_team?
        #Dashboard
        can :index, :dashboard
        # Brand related abilities
        can :manage, Brand
        #Invite related abilities
        can [:new_brand, :create], Invite
        #Startup related abilities
        can :create, [Startup, StartupDecorator]
        can :questions, [Startup, StartupDecorator] do |user|
          !user.owner_id.nil?
        end
        can [:index, :profile, :profile_activity, :notes, :watchlist,
             :edit_watchlist, :update_watchlist, :push, :new_add_to_list, :delete,
             :destroy, :create_add_to_list, :download, :search, :show, :tags,
             :activity, :update, :tasks, :add_pdf, :destroy_pdf, :cancel], [Startup, StartupDecorator]
        can [:read, :create], StartupProfileQuestion
        #Note related abilities
        can :create, [Note, NoteDecorator]
        can [:mark_task], [Note, NoteDecorator], Note.author_or_assignee(user) do |note|
          note.author_id == user.id || note.assignee_id == user.id
        end
        can [:delete, :destroy, :update], [Note, NoteDecorator], Note.author_or_assignee(user) do |note|
          note.author_id == user.id
        end
        can [:destroy, :update], [NoteComment, NoteCommentDecorator] do |comment|
          user.id == comment.author_id
        end
        #Tag related abilities
        can :create, Tag
        can [:read, :destroy], Tag, team: 'evo'
        #Invite related abilities
        can [:new_startup, :create], Invite
        #List related abilities
        can [:create, :add_to_favorites], List
        can [:read, :update, :remove_from], List, favorite: false, author_id: team_user_ids
        can [:read, :update, :remove_from_favorites], List, author_id: user.id, favorite: true
        can :destroy, List, author_id: user.id, favorite: false
        #Package related abilities
        can :manage, Package
        #Request related abilities
        can :answer, Request
        #Promo pages related abilities
        can [:view_questions, :preview], PromoPage
        can [:reject, :approve], PromoPage do |promo_page|
          promo_page.promo_page_status == 'waiting'
        end
        #, promo_page_status: ['waiting']
        # can [:show, :reject, :approve, :save_for_review, :unpublish], PromoPage
        # Search related ability
        can :read, UserInsightSummary
        can [:quick, :adv, :adv_filter, :advanced, :saved, :show, :new, :create, :edit], Search
        # can :diagnostic, :brand_users
        can [:read, :create, :upload_image, :preview], Announcement
        can [:index, :my_tasks, :assigned_tasks, :requests, :updates], Activity
        # Scorecard templates
        can [:index, :new, :create, :edit, :update, :show, :add_question,
             :cancel, :refresh, :refresh_persisted, :save, :destroy,
             :generate_xls], ScorecardTemplate
        # Scorecards
        can [:index, :new, :create, :edit, :update, :show, :cancel, :refresh,
             :refresh_persisted, :save, :destroy, :push, :preview,
             :preview_persisted, :download_list, :generate_pdf,
             :search_startups], Scorecard
        if user.evo_super?
          # Can set user role
          can :set_role, Invite
          can [:update, :destroy, :reset_password], User
          can [:update, :destroy, :edit_name, :update_name], Search, user_id: team_user_ids
        else
          can :set_role, Invite do |invite|
            invite.resource_id
          end
          can [:update, :reset_password], User, id: user.id
          can [:update, :destroy, :reset_password], User do |user|
            user.brand_team?
          end
          can [:update, :destroy, :edit_name, :update_name], Search, user_id: user.id
        end
        cannot :destroy, User, id: user.id
      when user.brand_team?
        #Dashboard
        can :index, :dashboard
        #Promo pages related abilities
        can [:read, :refresh, :refresh_persisted, :create_question, :update_question,
             :view_questions, :delete_question, :preview], PromoPage
        can :create, PromoPage if user.brand.promo_pages.size < user.brand.package.number_external_pages
        can [:update], PromoPage do |promo_page|
         ['inactive', 'published', 'rejected'].include?(promo_page.promo_page_status)
       end
        # , promo_page_status: ['inactive', 'published', 'rejected']
        can [:new_unpublish, :unpublish], PromoPage do |promo_page|
          promo_page.promo_page_status == 'published'
        end
        #, promo_page_status: ['published']
        #Startup related abilities
        can [:create, :index, :profile, :watchlist, :requests, :new_add_to_list,
             :create_add_to_list, :download, :show, :tags, :edit_watchlist,
             :update_watchlist, :notes], [Startup, StartupDecorator]
        cannot [:edit_watchlist, :update_watchlist], Startup, id: user.brand.pushed_startups.pluck(:id)
        can [:delete, :destroy], [Startup, StartupDecorator], creator_id: team_user_ids
        #Note related abilities
        can :create, [Note, NoteDecorator]
        can [:update, :delete, :destroy, :mark_task], [Note, NoteDecorator], Note.author_or_assignee(user) do |note|
          note.author_id == user.id || note.assignee_id == user.id
        end
        can [:destroy, :update], [NoteComment, NoteCommentDecorator] do |comment|
          user.id == comment.author_id
        end
        #Tag related abilities
        can :create, Tag
        can [:read, :destroy], Tag, team: 'brand'
        can :create, Invite if user.brand.package.unlimited_users? || user.brand.users.size < user.brand.package.number_users
        #Invite related abilities
        can [:new_startup], Invite
        #List related abilities
        can [:create, :add_to_favorites], List
        can [:read, :update, :remove_from], List, favorite: false, author_id: team_user_ids
        can [:read, :update, :remove_from_favorites], List, author_id: user.id, favorite: true
        can :destroy, List, author_id: user.id, favorite: false
        #Request related abilities
        can [:index], Request
        can [:index, :modify], :brand_brief
        # Search related ability
        can [:quick, :adv, :adv_filter, :advanced, :saved, :show, :new, :create, :edit, :by_categories], Search
        can :read, Announcement
        can [:index], Activity
        can [:create], Request

        # Scorecards
        can [:index, :show, :download_list, :generate_pdf], Scorecard
        if user.brand_super?
          can [:modify], BrandBrief
          can [:destroy], PromoPage do |promo_page|
            promo_page.promo_page_status == 'rejected'
          end
          # , promo_page_status: ['rejected']
          #Brand related abilities
          can [:show, :edit, :update, :brief, :startups, :users, :settings], Brand
          #Invite related abilities
          can [:set_role], Invite
          # can :diagnostic, User { |user| user.brand_team? }
          can [:update, :delete, :reset_password], User do |user|
            user.brand_team?
          end
          can :read, UserInsightSummary
          can [:update, :destroy, :edit_name, :update_name], Search, user_id: team_user_ids
        else
          can :read, UserInsightSummary, user_id: user.id
          can [:show, :brief, :startups, :users], Brand
          # can :diagnostic, User, id: user.id
          can [:update, :reset_password], User, id: user.id
          can [:update, :destroy, :edit_name, :update_name], Search, user_id: user.id
        end
        cannot :destroy, User, id: user.id
      when user.startup?
        #Startup related abilities
        can [:new, :create], StartupBrandBrief
        can :create, [Startup, StartupDecorator]
        can [:show, :home, :update, :all_questions, :cabinet, :add_pdf, :destroy_pdf], [Startup, StartupDecorator], owner_id: user.id
        can [:read, :update], StartupProfileQuestion, startup_id: user.startup_id
        can :show, PromoPage
        # can :read, Announcement
      else
        can :show, PromoPage
    end
  end
end
