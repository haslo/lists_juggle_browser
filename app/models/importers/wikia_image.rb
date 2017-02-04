module Importers
  class WikiaImage

    def fetch_all_images
      [Upgrade, Pilot].each do |klass|
        klass.all.each do |entity|
          find_image_for(entity)
          entity.save!
        end
      end
    end

    def fetch_missing_images
      [Upgrade, Pilot].each do |klass|
        klass.where(image_uri: nil).each do |entity|
          find_image_for(entity)
          entity.save!
        end
      end
    end

    def find_image_for(entity, given_uri = nil)
      if given_uri.present?
        result_uri = URI.parse(given_uri)
      else
        search_uri         = URI.parse("http://xwing-miniatures.wikia.com/wiki/Special:Search?search=#{URI.encode(entity.wikia_search_string)}")
        search_response    = Net::HTTP.get_response(search_uri)
        parsed_search_body = Nokogiri.parse(search_response.body)
        result_uri         = URI.parse(parsed_search_body.search('ul.Results li.result:first a:first').first.attributes['href'].value)
      end
      result_response    = Net::HTTP.get_response(result_uri)
      parsed_result_body = Nokogiri.parse(result_response.body)
      image_uri          = parsed_result_body.search('#WikiaArticle img').first.attributes['src'].value
      entity.assign_attributes({
                                 wikia_uri: result_uri,
                                 image_uri: image_uri,
                               })
    end

  end
end
