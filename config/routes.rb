Rails.application.routes.draw do
  # The five sections (SiteSection); Today is the home page.
  root "sections#today"
  get "pray", to: "sections#pray"
  get "bible", to: "sections#bible"
  get "kalendar", to: "sections#kalendar"
  get "atlas", to: "sections#atlas"

  get "about", to: "pages#about"
  get "sources", to: "sources#index"
  get "search", to: "searches#show", as: :search

  # Every destination in docs/urls.md, at its final address. Those whose phase
  # has not arrived are honest placeholders (DestinationsController).
  date = /\d{4}-\d{2}-\d{2}/
  slug = /[a-z0-9]+(?:-[a-z0-9]+)*/
  book = PrayerBook::ID_PATTERN
  planned = ->(path, destination, as:, **constraints) do
    get path, to: "destinations#show", defaults: { destination: destination }, constraints: constraints, as: as, format: false
  end

  scope "pray" do
    planned.("intercessions", "intercessions", as: :intercessions)
    planned.("my-prayers", "my_prayers", as: :my_prayers)
    planned.("confession", "confession", as: :confession)
    planned.(":book", "prayer_book", as: :prayer_book, book: book)
    planned.(":book/collects/:key", "collect", as: :collect, book: book, key: slug)
    planned.(":book/prayers/:key", "prayer", as: :prayer, book: book, key: slug)
    planned.(":book/offices/:key", "pastoral_office", as: :pastoral_office, book: book, key: slug)
    planned.(":book/:office(/:date)", "office", as: :office, book: book, office: Office::SLUG_PATTERN, date: date)
  end

  scope "bible" do
    planned.("psalter/:book", "psalter", as: :psalter, book: book)
    planned.("psalter/:book/day/:day", "psalter_day", as: :psalter_day, book: book, day: /\d{1,2}/)
    planned.("psalter/:book/:psalm", "psalm", as: :psalm, book: book, psalm: /\d{1,3}/)
    planned.("lectionaries/:key", "lectionary", as: :lectionary, key: slug)
    planned.("plans/:key", "reading_plan", as: :reading_plan, key: slug)
    planned.(":bible_book/:chapter(/:verses)", "passage", as: :passage, bible_book: slug, chapter: /\d{1,3}/, verses: /\d{1,3}(?:-\d{1,3})?/)
  end

  scope "kalendar" do
    planned.("easter/:year", "easter", as: :easter, year: /\d{4}/)
    planned.(":date", "kalendar_day", as: :kalendar_day, date: date)
    planned.(":year", "kalendar_year", as: :kalendar_year, year: /\d{4}/)
    planned.(":year/:month", "kalendar_month", as: :kalendar_month, year: /\d{4}/, month: /\d{2}/)
  end

  scope "atlas" do
    planned.("books/:book", "atlas_book", as: :atlas_book, book: book)
    planned.("prayers/:key", "atlas_prayer", as: :atlas_prayer, key: slug)
    planned.("compare/:key/:first/:second(/:third)", "compare", as: :compare, key: slug, first: book, second: book, third: book)
    planned.("lineage", "lineage", as: :lineage)
    planned.("learn", "learn", as: :learn)
    planned.("learn/:key", "learn_page", as: :learn_page, key: slug)
  end


  # Settings, and the choices made from it or from the footer.
  resource :settings, only: :show
  resource :appearance, only: :update
  resource :reading_settings, only: :update
  resource :book_preference, only: :update
  resource :site_mode, only: :update

  # Development aids, never routed in production: the type specimen (P2.4)
  # the component gallery (P2.5), and the block sample (P2.9).
  if Rails.env.local?
    get "dev/type", to: "dev#type", as: :dev_type
    get "dev/components", to: "dev#components", as: :dev_components
    get "dev/liturgy", to: "dev#liturgy", as: :dev_liturgy
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (BUILD.md P18.1 links them)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
