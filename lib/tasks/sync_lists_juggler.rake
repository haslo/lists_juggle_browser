require 'csv'

namespace :sync do

  task lists_juggler: :environment do
    ende = false
    id = 1
    importer = ListsJugglerImporter.new
    puts 'importing all tournaments...'
    until ende
      uri = URI.parse("http://lists.starwarsclubhouse.com/export_tourney_lists?tourney_id=#{id}")
      response = Net::HTTP.get_response(uri)
      if response.is_a?(Net::HTTPSuccess)
        data = CSV.parse(response.body)
        importer.process_data(id, data)
        id += 1
        print ".#{id}."
      else
        ende = true
      end
    end
    puts "\ndone!"
  end

end
