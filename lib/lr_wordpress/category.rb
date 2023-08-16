class WP::Category < WP::Base
  include ActiveModel::Model

  PATH = '/categories'
  SEARCH_FIELDS = [:context, :page, :per_page, :search, :exclude, :include, :order, :orderby, :hide_empty, :parent, :post, :slug]
  FIELDS = [:id, :count, :description, :link, :name, :slug, :taxonomy, :parent_id, :_links, :meta]

  attr_accessor *FIELDS

  def self.parse(raw = {})
    raw = raw.with_indifferent_access
    raw[:parent_id] = raw.delete :parent
    raw = raw.slice *FIELDS

    super raw
  end

  def self.find_by_name(name)
    all.find{ |category| category.name.downcase == name.downcase }
  end

  def self.find_by_slug(slug)
    all.find{ |category| category.slug == slug }
  end

  def self.all_in_hierarchy
    categories = Hash[all.reject{|c| c.count == 0 }.map{|c| [c.id, c] }]
    hierarchy = {}

    build_tree = lambda do |root, level_id, level_category|
      next_level_categories, categories = categories.partition{|id, c| c.parent_id == level_id }.map(&:to_h)
      next_level_categories.each do |next_level_id, next_level_category|
        root[next_level_category] ||= {}
        build_tree.call root[next_level_category], next_level_id, next_level_category
      end
    end

    build_tree.call hierarchy, 0, nil

    hierarchy
  end

  def parent
    @_parent ||= parent_id == 0 ? nil : WP::Category.find(parent_id)
  end

  def posts
    @_posts ||= WP::Post.all.select{|post| post.category_ids.include?(id) }
  end
end
