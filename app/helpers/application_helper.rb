module ApplicationHelper

  def link_with_filter_to(path, *args, &block)
    if path.start_with?('/')
      if path.include?('?')
        path += '&'
      else
        path += '?'
      end
    end
    ranking_configuration.each do |key, value|
      path += "#{key}=#{URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
    end
    link_to(path, *args, &block)
  end

end
