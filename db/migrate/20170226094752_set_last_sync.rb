class SetLastSync < ActiveRecord::Migration[5.0]

  def up
    timestamp = Time.parse(select_rows('select max(created_at) from tournaments')[0][0])
    execute("insert into key_value_store_records (key, value, created_at, updated_at) values ('last_sync', '\"#{timestamp.iso8601}\"', now(), now())")
  end

  def down
    execute("delete from key_value_store_records where key = 'last_sync'")
  end

end
