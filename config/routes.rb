Rails.application.routes.draw do

  match '/404', :to => 'errors#not_found', :via => :all

  devise_for :users, controllers: { sessions: 'users/sessions',
                                    registrations: 'users/registrations',
                                    passwords: 'users/passwords',
                                    confirmations: 'users/confirmations' }

  devise_scope :user do
    controller 'users/sessions' do
      get ':alias/sign_in' => :new, as: :new_brand_session
      post ':alias/sign_in' => :create, as: :brand_session
      root action: :new
    end
  end

  get '/dashboard', to: 'dashboard#index'
  resources :brands do
    resources :users, controller: 'brand_users' do
      member do
        get :activity
        get :diagnostic
      end
    end
    resources :startups, path_names: { new: 'push' }, controller: :brand_startups,
              only: [:index, :new, :create, :destroy] do
      get :delete, on: :member
    end
    member do
      patch :update_question
      delete :delete_question
      get :brief
      get :modify
      get :promo_pages
      get :settings
      controller :brands do
        patch 'refresh' => :refresh_persisted
      end
      get :delete
    end
    collection do
      post :create_question
      post 'refresh' => 'brands#refresh'
      get :search
    end
  end

  resources :email_templates
  resources :brand_questions
  resources :announcements
  post '/announcements/upload', to: 'announcements#upload_image',
                                as: :announcements_upload_image
  resources :users do
    member do
      post :reset_password
      get  :activity
      get  :diagnostic
    end
  end

  resources :activities do
    collection do
      get :requests
      get :updates
      get :my_tasks
      get :assigned_tasks
    end
  end

  resources :invites do
    get :new_startup, on: :collection
    get :delete, on: :member
  end

  resources :startups, path_names: { notes: 'comments' } do
    resources :announcements, controller: 'startup_announcements', only: [:index, :show]
    resources :tags, controller: :startup_tags, only: [:index, :create, :destroy]
    post :add_pdf
    delete 'destroy_pdf/:pdf_id' => 'startups#destroy_pdf', as: :destroy_pdf
    member do
      get :tags
      get :profile
      get :questions
      get :notes
      get :tasks
      get :home
      get :requests
      get :all_questions
      get :activity
      get :cabinet
      controller :startups do
        get 'push' => :new_push
        post 'push' => :create_push
        get 'add_to_list' => :new_add_to_list
        post 'add_to_list' => :create_add_to_list
      end
      get   :edit_watchlist
      patch :update_watchlist
      get   :delete
    end
    collection do
      put :cancel
      get :search
      get :watchlist
      post '/download/:type', to: 'startups#download', as: 'download'
    end
    resources :brief, controller: :startup_brief_summaries do
      get :to_step, on: :collection
    end
    resources :profile_questions, except: :destroy
  end

  resources :startup_brief_summaries

  resources :search do
    collection do
      post :quick
      get :quick
      get :saved
      get :advanced
      post :adv
      get :by_categories
      get 'adv', to: 'search#adv_filter'
      resources :tags, except: [:edit, :update] do
        collection do
          delete :delete_tag
        end
      end
    end
    member do
      get :edit_name
      patch :update_name
    end
  end

  resources :lists do
    get :remove_from, on: :member
    collection do
      get :search
      get :add_to_favorites
      get :remove_from_favorites
    end
  end
  put 'sort_lists', to: 'lists#sort', as: :sort_lists
  put 'reset_list_sorting', to: 'lists#reset_sorting', as: :reset_list_sorting

  resources :requests do
    get :seen, on: :member
  end
  resources :notes do
    resources :comments, controller: :note_comments, only: [:edit, :create, :update, :destroy]
    member do
      get :delete
      get :mark_as_done
      get :mark_as_undone
    end
  end

  resources :brand_brief_summaries
  resources :user_diagnostic_summaries

  scope 'settings' do
    get 'diagnostic', to: 'diagnostic#index'
    resources :diagnostic_questions
    resources :diagnostic_types, only: [:index, :edit, :update]
    resources :packages do
      get :delete, on: :member
    end
    resources :brand_brief do
      member do
        get :modify
      end
    end
    resources :promo_pages, except: [:show] do
      member do
        patch :update_question
        delete :delete_question
        get 'unpublish' => 'promo_pages#new_unpublish'
        patch :unpublish
        patch :reject
        patch :approve
        patch 'refresh' => 'promo_pages#refresh_persisted'
        get :view_questions
        get :preview
      end
      collection do
        post :create_question
        post 'refresh' => 'promo_pages#refresh'
        get :brand_questions
      end
    end
  end

  get '/promo/:alias', to: 'promo_pages#show', as: :promo

  scope path: '/startup_brand_brief', controller: :startup_brand_briefs do
    get ':brand_alias' => :new, as: :new_startup_brand_brief
    post ':brand_alias' => :create, as: :startup_brand_brief
  end

  scope path: '/startup_promo_brief', controller: :startup_promo_briefs do
    get ':promo_alias' => :new, as: :new_startup_promo_brief
    post ':promo_alias' => :create, as: :startup_promo_brief
  end


  resources :scorecards do
    collection do
      get 'show_by_token/:token' => 'scorecards#show_by_token', as: :show_by_token
      get 'cancel'
      post 'refresh'
      patch 'refresh_persisted'
      get 'download_list/:template_id' => 'scorecards#download_list', as: :download_list
      post 'generate_pdf' => 'scorecards#generate_pdf', as: :generate_pdf
      get 'search_startups'
    end
    patch 'push'
  end
  resources :scorecard_templates do
    get 'generate_xls'
    collection do
      patch 'refresh_persisted'
      post 'add_question'
      get 'cancel'
      post 'refresh'
    end
  end
end
