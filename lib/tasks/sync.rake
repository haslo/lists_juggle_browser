require 'csv'

namespace :sync do

  def import_tournament_table(start_at_id)
    importer        = Importers::ListsJuggler.new
    uri             = URI.parse('http://lists.starwarsclubhouse.com/tourneys')
    response        = Net::HTTP.get_response(uri)
    parsed_body     = Nokogiri.parse(response.body)
    tournament_rows = parsed_body.search('table#tourneys tbody tr')
    tournament_rows.each do |tournament_row|
      tournament_id = tournament_row.search('th').first.text
      print "#{tournament_id},"
      if start_at_id.nil? || tournament_id.to_i >= start_at_id.to_i
        importer.process_tournament(tournament_id, tournament_row)
        import_tournament_lists(importer, tournament_id)
        Importers::Ranking.new.build_ranking_data(tournament_id)
      end
    end
    Importers::WikiaImage.fetch_missing_images
  end

  def import_tournament_lists(importer, tournament_id)
    uri        = URI.parse("http://lists.starwarsclubhouse.com/export_tourney_lists?tourney_id=#{tournament_id}")
    response   = Net::HTTP.get_response(uri)
    quote_char = find_quote_char_for(response.body)
    data       = CSV.parse(response.body, :quote_char => quote_char)
    importer.process_data(tournament_id, data)
  end

  def find_quote_char_for(text)
    %w[| % ç £ @ °].detect { |c| !(text.include?(c)) }
  end

  task :all, [:start_at_id] => :environment do |_t, args|
    puts 'importing all tournaments...'
    import_tournament_table(args[:start_at_id])
    puts "\ndone!"
  end

  task rebuild_wikia_images: :environment do
    puts 'rebuilding all images...'
    Importers::WikiaImage.new.fetch_all_images
    puts "\ndone!"
  end

  task reset_icons: :environment do
    Ship.where(font_icon_class: nil).each do |ship|
      ship.update(font_icon_class: ship.name.downcase.gsub(/[^a-z0-9]/, ''))
    end
    {
      'Title'                    => 'title',
      'Crew'                     => 'crew',
      'Modification'             => 'modification',
      'System'                   => 'system',
      'Astromech Droid'          => 'astromech',
      'Turret Weapon'            => 'turret',
      'Missile'                  => 'missile',
      'Cannon'                   => 'cannon',
      'Bomb'                     => 'bomb',
      'Torpedo'                  => 'torpedo',
      'Illicit'                  => 'illicit',
      'Salvaged Astromech Droid' => 'salvagedastromech',
      'Tech'                     => 'tech',
      'Elite Pilot Talent'       => 'elite',
    }.each do |upgrade_type_name, font_icon_class|
      UpgradeType.where(name: upgrade_type_name).update_all(font_icon_class: font_icon_class)
    end
  end

  task rebuild_rankings: :environment do
    Importers::Ranking.new.rebuild_all_ranking_data
  end

end
