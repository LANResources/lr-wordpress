class WP::User < WP::Base
  include ActiveModel::Model

  PATH = '/users'
  SEARCH_FIELDS = [:context, :page, :per_page, :search, :exclude, :include, :offset,
                   :order, :orderby, :slug, :roles]
  FIELDS = [:id, :name, :url, :description, :link, :slug, :avatar_urls, :_links]

  attr_accessor *FIELDS

  def self.parse(raw = {})
    raw = raw.with_indifferent_access.slice *FIELDS

    super raw
  end
end
