require 'csv'

namespace :sync do

  task xwing_data: :environment do

  end

  task rebuild_rankings: :environment do
    Importers::Ranking.new.rebuild_all_ranking_data
  end

end
