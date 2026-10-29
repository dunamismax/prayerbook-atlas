Rails.application.routes.draw do
  # The five sections (SiteSection); Today is the home page.
  root "sections#today"
  get "pray", to: "sections#pray"
  get "bible", to: "sections#bible"
  get "kalendar", to: "sections#kalendar"
  get "atlas", to: "sections#atlas"

  get "about", to: "pages#about"

  # The footer's choice between the phone site and the full site.
  resource :site_mode, only: :update

  # Development aids, never routed in production: the type specimen (P2.4)
  # and the component gallery (P2.5).
  if Rails.env.local?
    get "dev/type", to: "dev#type", as: :dev_type
    get "dev/components", to: "dev#components", as: :dev_components
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (BUILD.md P18.1 links them)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
