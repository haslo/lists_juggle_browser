class KeyValueStoreRecord < ApplicationRecord

  def self.get(key)
    find_by(key: key).value
  end

  def self.set!(key, value)
    record = find_or_initialize_by(key: key)
    record.value = value
    record.save!
  end

end
