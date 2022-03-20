# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'roots#show'

  resource :root, only: :show
  resource :results, only: %i[create show]
end
