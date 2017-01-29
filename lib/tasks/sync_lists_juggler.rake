require 'csv'

namespace :sync do

  def import_tournament_table
    importer = ListsJugglerImporter.new
    uri = URI.parse('http://lists.starwarsclubhouse.com/tourneys')
    response = Net::HTTP.get_response(uri)
    parsed_body = Nokogiri.parse(response.body)
    tournament_rows = parsed_body.search('table#tourneys tbody tr')
    tournament_rows.each do |tournament_row|
      tournament_id = tournament_row.search('th').first.text
      importer.process_tournament(tournament_row)
      import_tournament_lists(importer, tournament_id)
    end
  end

  def import_tournament_lists(importer, tournament_id)
    uri      = URI.parse("http://lists.starwarsclubhouse.com/export_tourney_lists?tourney_id=#{tournament_id}")
    response = Net::HTTP.get_response(uri)
    data = CSV.parse(response.body, :quote_char => '£')
    importer.process_data(tournament_id, data)
    print ".#{tournament_id}."
  end

  task lists_juggler: :environment do
    puts 'importing all tournaments...'
    import_tournament_table
    puts "\ndone!"
  end

end
