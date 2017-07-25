class SetLastSync < ActiveRecord::Migration[5.0]

  def up
    database_time = select_rows('select max(created_at) from tournaments')[0][0]
    if database_time.present?
      timestamp = Time.parse(database_time)
      execute("insert into key_value_store_records (key, value, created_at, updated_at) values ('last_sync', '\"#{timestamp.iso8601}\"', now(), now())")
    end
  end

  def down
    execute("delete from key_value_store_records where key = 'last_sync'")
  end

end
