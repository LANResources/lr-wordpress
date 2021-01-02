class WP::Base
  include HTTParty
  base_uri Rails.application.config.wordpress_api_base_url
  logger Rails.logger, :info

  PATH = '/'
  SEARCH_FIELDS = []

  class << self
    def all
      Rails.cache.fetch([name, 'all', cache_key]) do
        results = []
        initial_response = fetch path: "#{self::PATH}", options: { query: { per_page: 100, page: 1 }}
        total = initial_response.total
        total_pages = initial_response.total_pages

        results += load initial_response

        if total_pages > 1
          (2..total_pages).each do |page|
            results += load(fetch path: "#{self::PATH}", options: { query: { per_page: 100, page: page}})
          end
        end
        results
      end
    end

    def count
      Rails.cache.fetch([name, 'count', cache_key]) do
        fetch(path: self::PATH).total
      end
    end

    def fetch(path:, options: {})
      new.handle_request path: path, options: options
    end

    def parse(raw = {})
      self.new raw
    end

    def load(response)
      Array(response.parsed_response).map{|obj| self.parse obj }
    end

    def find(*ids)
      found_cached = all.select{|item| item.id.in?(ids)}
      found = found_cached.any? ? found_cached : load(fetch path: "#{self::PATH}", options: {query: { include: ids}})

      if found.any?
        ids.count == 1 ? found.first : found
      else
        nil
      end
    end

    def search(options = {})
      options.slice! *self::SEARCH_FIELDS
      response = fetch(path: self::PATH, options: { query: options })
      OpenStruct.new count: response.total,
                     total_pages: response.total_pages,
                     results: load(response)
    end

    def cache_keys
      Rails.cache.fetch('wp-cache-keys', expires_in: 10.minutes) do
        fetch(path: '/cache-keys').parsed_response
      end
    end

    def cache_key
      cache_keys[name.split('::').last.downcase.pluralize]
    end
  end

  def handle_request(action: :get, path:, options: {})
    options[:headers] = { 'Authorization' => "Basic #{Rails.application.config.wordpress_api_auth_header}" }
    WP::Response.new self.class.send(action, Addressable::URI.escape(path), options)
  end

  protected

  def handle_timeouts
    begin
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      false
    end
  end

  def log(name, msg)
    Rails.logger.info "[WP] [#{name}] #{msg}"
  end
end
