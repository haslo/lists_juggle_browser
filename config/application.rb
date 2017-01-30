require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ListJuggleBrowser
  class Application < Rails::Application

    config.time_zone = 'Bern'
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]
    config.i18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

  end
end
