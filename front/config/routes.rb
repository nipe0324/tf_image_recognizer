Rails.application.routes.draw do
  root 'root#index'
  post 'api' => 'root#api'
end
