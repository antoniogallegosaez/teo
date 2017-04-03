# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'erase_configuration', to: "teo_setup_settings#erase", as: :erase_configuration
get 'load_configuration', to: "teo_setup_settings#load", as: :load_configuration
