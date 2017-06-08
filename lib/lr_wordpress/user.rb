class WP::User < WP::Base
  include ActiveModel::Model

  PATH = '/users'
  SEARCH_FIELDS = [:context, :page, :per_page, :search, :exclude, :include, :offset,
                   :order, :orderby, :slug, :roles]

  attr_accessor :id, :name, :url, :description, :link, :slug, :avatar_urls, :_links
end
