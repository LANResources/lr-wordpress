class WP::Response < SimpleDelegator
  def total
    headers.fetch('x-wp-total', 0).to_i
  end

  def total_pages
    headers.fetch('x-wp-totalpages', 0).to_i
  end
end
