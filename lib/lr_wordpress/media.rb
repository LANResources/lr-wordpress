class WP::Media < WP::Base
  include ActiveModel::Model

  PATH = '/media'
  SEARCH_FIELDS = [:context, :page, :per_page, :search, :after, :author, :author_exclude, :before,
                   :exclude, :include, :offset, :order, :orderby, :parent, :parent_exclude, :slug,
                   :status, :filter, :media_type, :mime_type]

  attr_accessor :id, :date, :date_gmt, :guid, :modified, :modified_gmt, :slug, :type, :link,
                :title, :author_id, :comment_status, :ping_status, :alt_text, :caption, :description,
                :media_type, :mime_type, :media_details, :post_id, :source_url, :_links, :template, :meta

  def self.parse(raw = {})
    raw = raw.with_indifferent_access
    [:date, :date_gmt, :modified, :modified_gmt].each{|a| raw[a] = DateTime.parse raw[a] }
    [:guid, :title].each{|a| raw[a] = raw[a][:rendered] }
    {author: :author_id, post: :post_id}.each do |k,v|
      raw[v] = raw.delete k
    end

    super raw
  end

  def author
    WP::User.find author_id
  end

  def post
    @_post ||= WP::Post.find post_id
  end
end
