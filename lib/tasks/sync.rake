require 'csv'

namespace :sync do

  desc 'xwing-data'
  task xwing_data: :environment do
    Importers::XwingData.new.sync_all
  end

  desc 'lists juggler'
  task :tournaments, [:minimum_id, :start_date] => :environment do |t, args|
    Importers::ListsJuggler.new.sync_tournaments(minimum_id: args[:minimum_id].to_i, start_date: args[:start_date])
  end

  desc 'rankings'
  task rebuild_rankings: :environment do
    Importers::Ranking.new.rebuild_all_ranking_data
  end

end
