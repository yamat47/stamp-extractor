# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'roots#show'

  resource :root, only: :show
  resources :results, only: %i[create show]
  resources :temporary_images, only: :show
end
