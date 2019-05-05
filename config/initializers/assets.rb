# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w( turning_test.js )
Rails.application.config.assets.precompile += %w( dom-to-image.min.js )
Rails.application.config.assets.precompile += %w( chartkick.js )