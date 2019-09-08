Rails.application.routes.draw do
  get 'consultations/index'

  root 'consultations#index'
end
