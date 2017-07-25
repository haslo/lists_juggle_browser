require 'csv'

namespace :sync do

  desc 'xwing-data'
  task xwing_data: :environment do
    Importers::XwingData.new.sync_all
  end

  desc 'lists juggler'
  task :tournaments, [:minimum_id] => :environment do |t, args|
    Importers::ListsJuggler.new.sync_tournaments(minimum_id: args[:minimum_id].to_i, add_missing: false)
  end

  task recent_tournaments: :environment do
    Importers::ListsJuggler.new.sync_tournaments(start_date: 1.month.ago.iso8601, add_missing: true)
  end

  desc 'rankings'
  task :rebuild_rankings, [:minimum_id, :start_date] => :environment do |t, args|
    Importers::Ranking.new.rebuild_all_ranking_data(minimum_id: args[:minimum_id].to_i, start_date: args[:start_date])
  end

  desc 'enable sync mode'
  task enable: :environment do
    KeyValueStoreRecord.set!('syncing', true)
  end

  desc 'disable sync mode'
  task disable: :environment do
    KeyValueStoreRecord.set!('syncing', false)
    KeyValueStoreRecord.set!('last_sync', Time.current.iso8601)
  end

end
