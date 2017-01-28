require 'csv'

namespace :sync do

  task lists_juggler: :env do
    ende = false
    id = 1
    facade = ListsJugglerFacade.new
    until ende
      uri = URI.parse("http://lists.starwarsclubhouse.com/export_tourney_lists?tourney_id=#{id}")
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        data = CSV.parse(response.body)
        facade.process_data(id, data)
        id += 1
      else
        ende = true
      end
    end
  end

end
