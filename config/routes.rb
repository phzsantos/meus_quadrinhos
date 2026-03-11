# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :characters, path: "personagens"
  resources :collections, path: "colecoes"
  resources :publication_types, path: "tipos_de_hq"
  resources :authors, path: "autores"
  resources :paper_types, path: "papel"
  resources :book_bindings, path: "encadernacoes"
  resources :publishers, path: "editoras"
  resources :comics, path: "quadrinhos" do
    collection do
      get :export
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "welcome#index"
end
