Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'

  resources :unidades, only: [:index, :edit, :new, :create, :update, :show, :destroy]
  resources :posts, only: [:index, :edit, :new, :create, :update, :show, :destroy]

  resources :areas, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :areas do
    get :autocomplete_titulo_unidade_medida, on: :collection
  end
  get 'areas/:id/vaga' => 'areas#vaga', as: 'area_vaga'

  resources :editais, only: [:index, :new, :edit, :create, :update, :show, :destroy]
  get 'editais/:id/word' => 'editais#word', format: 'rtf', as: 'edital_word'
  get 'editais/:id/pdf' => 'editais#pdf', as: 'edital_pdf'
  get 'editais/:id/publicar' => 'editais#publicar', as: 'publicar_edital'
  get 'editais/:id/baixar_pdf' => 'editais#baixar_pdf', as: 'baixar_edital'

  resources :vagas, only: [:index, :new, :create, :edit, :update, :show, :destroy]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
