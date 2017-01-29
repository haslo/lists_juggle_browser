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
      if tournament_id.to_i > 341
        import_tournament_lists(importer, tournament_id)
      end
    end
  end

  def import_tournament_lists(importer, tournament_id)
    begin
      uri      = URI.parse("http://lists.starwarsclubhouse.com/export_tourney_lists?tourney_id=#{tournament_id}")
      response = Net::HTTP.get_response(uri)
      quote_char = find_quote_char_for(response.body)
      data = CSV.parse(response.body, :quote_char => quote_char)
      importer.process_data(tournament_id, data)
      print ".#{tournament_id}."
    rescue => e
      require 'pry'; binding.pry
    end
  end

  def find_quote_char_for(text)
    %w[| % ç £ @ °].detect { |c| !(text.include?(c)) }
  end

  task lists_juggler: :environment do
    puts 'importing all tournaments...'
    import_tournament_table
    puts "\ndone!"
  end

end
