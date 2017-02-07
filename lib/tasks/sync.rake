require 'csv'

namespace :sync do

  task xwing_data: :environment do
    Importers::XwingData.new.sync_all
  end

  task tournaments: :environment do
    Importers::ListsJuggler
  end

  task rebuild_rankings: :environment do
    Importers::Ranking.new.rebuild_all_ranking_data
  end

end
