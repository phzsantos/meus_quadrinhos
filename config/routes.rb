# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :characters, path: "personagens" do
    collection do
      get :export
    end
  end
  resources :collections, path: "colecoes" do
    collection do
      get :export
    end
  end
  resources :publication_types, path: "tipos_de_hq" do
    collection do
      get :export
    end
  end
  resources :authors, path: "autores" do
    collection do
      get :export
    end
  end
  resources :paper_types, path: "papel" do
    collection do
      get :export
    end
  end
  resources :book_bindings, path: "encadernacoes" do
    collection do
      get :export
    end
  end
  resources :publishers, path: "editoras" do
    collection do
      get :export
    end
  end
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
