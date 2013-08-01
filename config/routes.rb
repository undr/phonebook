Phonebook::Application.routes.draw do
  root to: 'phones#index'
  resources :phones, except: :show do
    post :import, on: :collection, action: :process_import
    get :import, on: :collection
    get :export, on: :collection
    get :delete, on: :member
    delete :delete, on: :member, action: :destroy
  end
end
