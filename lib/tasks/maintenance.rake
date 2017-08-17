namespace :maintenance do

  desc 'enable maintenance mode'
  task enable: :environment do
    KeyValueStoreRecord.set!('maintenance', true)
  end

  desc 'enable maintenance mode'
  task disable: :environment do
    KeyValueStoreRecord.set!('maintenance', false)
  end

end
