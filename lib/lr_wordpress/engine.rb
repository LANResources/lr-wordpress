module WP
  class Engine < ::Rails::Engine
    initializer 'lr-wordpress' do |app|
      require "lr_wordpress/error"
      require "lr_wordpress/response"
      require "lr_wordpress/base"
      require "lr_wordpress/category"
      require "lr_wordpress/media"
      require "lr_wordpress/post"
      require "lr_wordpress/user"

      require 'base64'
      Rails.application.config.wordpress_api_auth_header = "Basic #{[Rails.application.config.wordpress_api_user,Base64.encode64(Rails.application.config.wordpress_api_key)].join(':')}"
    end
  end
end
