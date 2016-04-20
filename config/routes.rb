Rails.application.routes.draw do

  resources :topics do
    resources :posts do #, except: [:index] do
      resources :sponsored_posts, except: [:index]
    end

  end

  get 'about' => 'welcome#about'

  root 'welcome#index'
end
