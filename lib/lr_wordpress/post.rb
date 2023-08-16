class WP::Post < WP::Base
  include ActiveModel::Model

  PATH = '/posts'
  SEARCH_FIELDS = [:context, :page, :per_page, :search, :after, :author, :author_exclude, :before, :exclude,
                    :include, :offset, :order, :orderby, :slug, :status, :filter, :categories, :tags]
  FIELDS = [:id, :date, :date_gmt, :guid, :modified, :modified_gmt, :slug, :type, :link,
            :title, :content, :excerpt, :author_id, :featured_media_id, :comment_status, :ping_status,
            :sticky, :format, :category_ids, :tag_ids, :_links, :meta, :template, :status]

  attr_accessor *FIELDS

  def self.parse(raw = {})
    raw = raw.with_indifferent_access
    [:date, :date_gmt, :modified, :modified_gmt].each{|a| raw[a] = DateTime.parse raw[a] }
    [:guid, :title, :content, :excerpt].each{|a| raw[a] = raw[a][:rendered] }
    {author: :author_id, featured_media: :featured_media_id, categories: :category_ids, tags: :tag_ids}.each do |k,v|
      raw[v] = raw.delete k
    end
    raw = raw.slice *FIELDS

    super raw
  end

  def self.find_by_slug(slug)
    all.find{ |post| post.slug == slug }
  end

  def main_category
    @_main_category ||= category_ids.map{|category| WP::Category.find(category) }.compact.reject{|category| category.parent_id.present? && category.parent_id != 0 }.first
  end

  def featured_media
    @_featured_media ||= WP::Media.find featured_media_id
  end

  def author
    @_author ||= WP::User.find author_id
  end
end
