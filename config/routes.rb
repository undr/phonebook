Phonebook::Application.routes.draw do
  root to: 'phones#index'
  resources :phones, except: :show do
    get :delete, on: :member
    delete :delete, on: :member, action: :destroy
  end
end
